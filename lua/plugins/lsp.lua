---@class LspConfig
---@field mason? boolean
---@field settings? table
---@field cmd? string[]
---@field filetypes? string[]
---@field capabilities? table
---@field on_attach? fun(client, bufnr)
---@field [string]: any

---@type table<string, LspConfig>
local servers = {
    ts_ls = {},
    angularls = {},
    tailwindcss = {},
    pyright = {},
    html = {},
    cssls = {},
    jsonls = {},
    eslint = {},

    csharpier = {
        enable = false,
    },
    omnisharp = {
        enable = false,
        enable_roslyn_analysers = true,
        enable_import_completion = true,
        organize_imports_on_format = true,
        enable_decompilation_support = true,
        filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' },
    },

    lua_ls = {
        enable = true,
        settings = {
            Lua = {
                completion = { callSnippet = 'Replace' },
            },
        },
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
    },

    dartls = {
        mason = false,
        enable = false,
        cmd = { "dart", "language-server", "--protocol=lsp" },
    },
}

-- plugins that help with certain languages
local typescript_plugins = {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function(client, bufnr)
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- TypeScript code actions
                map("n", "<leader>co", function() vim.cmd("TSToolsOrganizeImports") end, "[C]ode: [O]rganize Imports")
                map("n", "<leader>ca", function() vim.cmd("TSToolsAddMissingImports") end,
                    "[C]ode: [A]dd Missing Imports")
                map("n", "<leader>cu", function() vim.cmd("TSToolsRemoveUnused") end, "[C]ode: Remove [U]nused")
                map("n", "<leader>cf", function() vim.cmd("TSToolsFixAll") end, "[C]ode: [F]ix All")
                map("n", "<leader>cR", function() vim.cmd("TSToolsRenameFile") end, "[C]ode: [R]ename File")
                map("n", "<leader>cS", function() vim.cmd("TSToolsSelectTSVersion") end, "[C]ode: [S]elect TS Version")

                -- Format on save if available
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end,
            settings = {
                tsserver_plugins = {

                },
            },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
        ft = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "angular",
            "vue",
            "svelte",
        },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
            })
        end,
    },
    -- Better commenting with treesitter context
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}



local extraLangsPlugins = {
    typescript_plugins,
}



-- Helper: split servers by mason support and filter enabled ones
local function split_servers(tbl)
    local mason = {}
    local manual = {}
    for name, config in pairs(tbl) do
        if config.enable ~= false then
            if config.mason ~= false then
                table.insert(mason, name)
            else
                table.insert(manual, name)
            end
        end
    end
    return mason, manual
end

-- Helper: get only enabled servers for mason-lspconfig
local function get_enabled_servers(tbl)
    local enabled = {}
    for name, config in pairs(tbl) do
        if config.enable ~= false then
            -- shallow copy to avoid mutating original config
            local conf = vim.tbl_deep_extend("force", {}, config)

            -- remove the enable key
            conf.enable = nil

            enabled[name] = conf
        end
    end
    return enabled
end


local function default_on_attach(client, bufnr)
    -- Format on save for LSPs that support it
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
end


return {
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp',
            { "mason-org/mason.nvim" },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim" },
            -- LSP UI/Health
            { "folke/trouble.nvim" },

            -- Completion Capabilities
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- setup local items
            require("fidget").setup({})
            require("mason").setup()

            local enabled_servers = get_enabled_servers(servers)
            local mason_lsps, manual_lsps = split_servers(enabled_servers)


            -- Install Mason-based servers
            require("mason-tool-installer").setup {
                ensure_installed = mason_lsps,
            }

            -- Mason LSP setups via mason-lspconfig
            require("mason-lspconfig").setup {
                handlers = {
                    function(server_name)
                        local config = enabled_servers[server_name] or {}
                        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
                        config.on_attach = config.on_attach or default_on_attach
                        require("lspconfig")[server_name].setup(config)
                    end,
                },
            }

            -- Manual LSP setups (non-Mason)
            for _, name in ipairs(manual_lsps) do
                local config = enabled_servers[name] or {}
                config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
                config.on_attach = config.on_attach or default_on_attach
                require("lspconfig")[name].setup(config)
            end

            -- Diagnostics config
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN]  = "󰀪 ",
                        [vim.diagnostic.severity.INFO]  = "󰋽 ",
                        [vim.diagnostic.severity.HINT]  = "󰌶 ",
                    },
                } or {},
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        return diagnostic.message
                    end,
                },
            }
        end
    },
    extraLangsPlugins
}
