-- Define all desired servers
---@class LspServer
---@field mason boolean? Whether to install via Mason (default: true)
---@field config table? lspconfig setup overrides

---@type table<string, LspServer>
local servers = {
    ts_ls = {
        config = function()
            require("typescript-tools").setup({
                settings = {
                    separate_diagnostic_server = true,
                    publish_diagnostic_on = "insert_leave",
                },
            })
            return true -- we handle tsserver via typescript-tools.nvim
        end,
    },
    angularls = {},
    tailwindcss = {},
    pyright = {}, -- python

    -- Make sure you have installed vscode-langservers-extracted globally
    -- https://github.com/vscode-langservers/vscode-langservers-extracted
    html = {},
    cssls = {},
    jsonls = {},
    eslint = {},


    lua_ls = {
        config = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        },
    },
    omnisharp = {},
    dartls = {
        mason = false, -- dartls not supported via Mason
        config = {
            cmd = { "dart", "language-server", "--protocol=lsp" },
        },
    },
}


local typescript_plugins = {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = { "BufReadPre", "BufNewFile" }, -- ensures LSP is set up before opening files
        opts = {},
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
    typescript_plugins,
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = function()
            local mason_servers = {}
            for name, info in pairs(servers) do
                if info.mason ~= false then
                    table.insert(mason_servers, name)
                end
            end

            return {
                ensure_installed = mason_servers,
                automatic_installation = false,
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- shared on_attach for keybindings
            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                end

                map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
                map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame Symbol")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })
            end

            -- capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            for name, info in pairs(servers) do
                if type(info.config) == "function" then
                    local handled = info.config()
                    if handled then goto continue end
                end

                lspconfig[name].setup(vim.tbl_deep_extend("force", {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }, info.config or {}))

                ::continue::
            end
        end,
    },
}
