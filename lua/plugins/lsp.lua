-- ~/.config/nvim/lua/plugins/lsp.lua
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
    prettierd = {},

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

-- Helper: split servers by mason support
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

-- Default on_attach behavior
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

                map("n", "gr", vim.lsp.buf.references, "Go to [R]eferences")

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
                tsserver_plugins = {},
            },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {},
    },
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}

return {
    unpack(typescript_plugins),
    -- {
    --     "nvimtools/none-ls.nvim",
    --     event = "VeryLazy",
    --     otps = {
    --         sources = {
    --             require("none-ls").builtins.formatting.prettierd
    --         },
    --         on_attach = function(client, bufnr)
    --             if client.supports_method("textDocument/formatting") then
    --                 vim.api.nvim_create_autocmd("BufWritePre", {
    --                     buffer = bufnr,
    --                     callback = function()
    --                         vim.lsp.buf.format({ async = false })
    --                     end,
    --                 })
    --             end
    --         end,
    --     }
    -- },
    -- Core LSP Setup
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- LSP UI/Health
            { "j-hui/fidget.nvim",    opts = {} },
            { "folke/trouble.nvim",   opts = {} },

            -- Completion Capabilities
            "hrsh7th/cmp-nvim-lsp",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local mason_lsps, manual_lsps = split_servers(servers)



            -- Mason LSP setups via mason-lspconfig
            require("mason-lspconfig").setup {
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local config = servers[server_name] or {}
                        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
                        config.on_attach = config.on_attach or default_on_attach
                        require("lspconfig")[server_name].setup(config)
                    end,
                },
            }


            -- Install Mason-based servers
            require("mason-tool-installer").setup {
                ensure_installed = mason_lsps,
            }

            -- Manual LSP setups (non-Mason)
            for _, name in ipairs(manual_lsps) do
                local config = servers[name] or {}
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
        end,
    },
}
