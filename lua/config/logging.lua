local M = {}

-- Get the Neovim config directory
local config_dir = vim.fn.stdpath('config')
local log_dir = config_dir .. '/logs'

-- Ensure log directory exists
vim.fn.mkdir(log_dir, 'p')

-- Log file paths
local log_files = {
    general = log_dir .. '/nvim.log',
    lsp = log_dir .. '/lsp.log',
    errors = log_dir .. '/errors.log',
    plugins = log_dir .. '/plugins.log',
    startup = log_dir .. '/startup.log'
}

-- Log levels
local LOG_LEVELS = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4
}

-- Current log level (can be changed)
M.current_level = LOG_LEVELS.INFO

-- Helper function to write to log file
local function write_to_log(file_path, level, message, source)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local log_entry = string.format('[%s] [%s] %s: %s\n',
        timestamp,
        level,
        source or 'NVIM',
        message
    )

    local file = io.open(file_path, 'a')
    if file then
        file:write(log_entry)
        file:close()
    end
end

-- Main logging function
function M.log(level, message, source, log_type)
    -- Check if we should log this level
    if LOG_LEVELS[level] < M.current_level then
        return
    end

    log_type = log_type or 'general'
    local file_path = log_files[log_type] or log_files.general

    write_to_log(file_path, level, tostring(message), source)

    -- Also log errors to the general error log
    if level == 'ERROR' and log_type ~= 'errors' then
        write_to_log(log_files.errors, level, tostring(message), source)
    end
end

-- Convenience functions
function M.debug(message, source, log_type)
    M.log('DEBUG', message, source, log_type)
end

function M.info(message, source, log_type)
    M.log('INFO', message, source, log_type)
end

function M.warn(message, source, log_type)
    M.log('WARN', message, source, log_type)
end

function M.error(message, source, log_type)
    M.log('ERROR', message, source, log_type)
end

-- Setup function to initialize all logging
function M.setup()
    -- Log startup
    M.info('Neovim started', 'INIT', 'startup')

    -- Override vim.notify to also log notifications
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
        local log_level = 'INFO'
        if level == vim.log.levels.WARN then
            log_level = 'WARN'
        elseif level == vim.log.levels.ERROR then
            log_level = 'ERROR'
        elseif level == vim.log.levels.DEBUG then
            log_level = 'DEBUG'
        end

        M.log(log_level, msg, opts and opts.title or 'NOTIFY')
        return original_notify(msg, level, opts)
    end

    -- Capture Lua errors
    local original_error = error
    _G.error = function(msg, level)
        M.error('Lua error: ' .. tostring(msg), 'LUA_ERROR')
        return original_error(msg, level)
    end

    -- Log LSP events
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LoggingLspAttach", { clear = true }),
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                M.info(string.format('LSP attached: %s (id: %d)', client.name, client.id), 'LSP', 'lsp')
            end
        end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("LoggingLspDetach", { clear = true }),
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                M.info(string.format('LSP detached: %s (id: %d)', client.name, client.id), 'LSP', 'lsp')
            end
        end,
    })

    -- Log plugin loading (lazy.nvim specific)
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        group = vim.api.nvim_create_augroup("LoggingPluginLoad", { clear = true }),
        callback = function(args)
            M.info(string.format('Plugin loaded: %s', args.data), 'LAZY', 'plugins')
        end,
    })

    -- Log vim errors and exceptions
    vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("LoggingErrorCapture", { clear = true }),
        callback = function()
            -- Set up global error handling
            vim.v.errmsg = ""

            -- Check for errors periodically (every 5 seconds)
            local function check_errors()
                if vim.v.errmsg ~= "" then
                    M.error(vim.v.errmsg, 'VIM_ERROR')
                    vim.v.errmsg = ""
                end
            end

            -- Create timer for periodic error checking
            local timer = vim.loop.new_timer()
            if timer then
                timer:start(5000, 5000, vim.schedule_wrap(check_errors))
            end
        end,
    })

    -- Log when nvim exits
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("LoggingExit", { clear = true }),
        callback = function()
            M.info('Neovim exiting', 'EXIT')
        end,
    })

    -- Create user commands for log management
    vim.api.nvim_create_user_command("LogView", function(opts)
        local log_type = opts.args ~= "" and opts.args or "general"
        local file_path = log_files[log_type]

        if file_path and vim.fn.filereadable(file_path) == 1 then
            vim.cmd('split ' .. file_path)
            -- Set filetype for syntax highlighting
            vim.bo.filetype = 'log'
            -- Make it read-only
            vim.bo.readonly = true
            vim.bo.modifiable = false
            -- Go to end of file
            vim.cmd('normal! G')
        else
            vim.notify('Log file not found: ' .. (file_path or 'unknown'), vim.log.levels.ERROR)
        end
    end, {
        nargs = '?',
        complete = function()
            return vim.tbl_keys(log_files)
        end,
        desc = 'View log file (general, lsp, errors, plugins, startup)'
    })

    vim.api.nvim_create_user_command("LogClear", function(opts)
        local log_type = opts.args ~= "" and opts.args or "all"

        if log_type == "all" then
            for _, file_path in pairs(log_files) do
                local file = io.open(file_path, 'w')
                if file then
                    file:close()
                end
            end
            vim.notify('All log files cleared', vim.log.levels.INFO)
        else
            local file_path = log_files[log_type]
            if file_path then
                local file = io.open(file_path, 'w')
                if file then
                    file:close()
                    vim.notify('Log file cleared: ' .. log_type, vim.log.levels.INFO)
                end
            else
                vim.notify('Unknown log type: ' .. log_type, vim.log.levels.ERROR)
            end
        end
    end, {
        nargs = '?',
        complete = function()
            local options = vim.tbl_keys(log_files)
            table.insert(options, 'all')
            return options
        end,
        desc = 'Clear log file(s)'
    })

    vim.api.nvim_create_user_command("LogLevel", function(opts)
        local level = opts.args:upper()
        if LOG_LEVELS[level] then
            M.current_level = LOG_LEVELS[level]
            M.info('Log level set to: ' .. level, 'LOGGING')
            vim.notify('Log level set to: ' .. level, vim.log.levels.INFO)
        else
            vim.notify('Invalid log level. Use: DEBUG, INFO, WARN, ERROR', vim.log.levels.ERROR)
        end
    end, {
        nargs = 1,
        complete = function()
            return { 'DEBUG', 'INFO', 'WARN', 'ERROR' }
        end,
        desc = 'Set logging level'
    })

    -- Keymaps for quick log access
    vim.keymap.set('n', '<leader>lv', ':LogView<CR>', { desc = 'View general log' })
    vim.keymap.set('n', '<leader>le', ':LogView errors<CR>', { desc = 'View error log' })
    vim.keymap.set('n', '<leader>ll', ':LogView lsp<CR>', { desc = 'View LSP log' })
    vim.keymap.set('n', '<leader>lp', ':LogView plugins<CR>', { desc = 'View plugin log' })
    vim.keymap.set('n', '<leader>lc', ':LogClear<CR>', { desc = 'Clear all logs' })
end

-- Function to rotate logs (prevent them from getting too large)
function M.rotate_logs()
    for log_type, file_path in pairs(log_files) do
        local stat = vim.loop.fs_stat(file_path)
        if stat and stat.size > 10 * 1024 * 1024 then -- 10MB
            local backup_path = file_path .. '.old'
            vim.loop.fs_rename(file_path, backup_path)
            M.info('Log rotated: ' .. log_type, 'LOGGING')
        end
    end
end

-- Auto-rotate logs on startup
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("LogRotation", { clear = true }),
    callback = function()
        vim.defer_fn(M.rotate_logs, 1000)
    end,
})

return M
