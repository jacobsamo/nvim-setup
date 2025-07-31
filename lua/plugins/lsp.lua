-- LazyVim already setups up lspconfig for you but we are going to configure it to lazy load certain servers
-- some of which are supported by mason and some which are not (e.g dart)

-- TODO: make the below servers work correctly
-- define all servers here, if they are supported by mason then set mason = false
-- local servers = {
--     ts_ls = {}, -- TypeScript/JavaScript LSP
--     angularls = {
--         root_pattern = { '.angular-cli.json', 'angular.json' },
--     },            -- Angular LSP
--     tailwindcss = {},
--     pyright = {}, -- python

--     -- biome = {}, -- uncomment if you use biome in any of your projects
--     -- prettier = {}, -- uncomment if you use prettier in any of your projects

--     -- Make sure you have installed vscode-langservers-extracted globally
--     -- https://github.com/vscode-langservers/vscode-langservers-extracted
--     html = {},
--     cssls = {},
--     jsonls = {},
--     eslint = {},

--     -- cmake = {},

--     -- Dotnet / C# developement
--     omnisharp = {
--         enable_roslyn_analysers = true,
--         enable_import_completion = true,
--         organize_imports_on_format = true,
--         enable_decompilation_support = true,
--         filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' },
--     },
--     -- csharp_ls = {},

--     lua_ls = {
--         -- cmd = {...},
--         -- filetypes = { ...},
--         -- capabilities = {},
--         settings = {
--             Lua = {
--                 completion = {
--                     callSnippet = 'Replace',
--                 },
--                 -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--                 -- diagnostics = { disable = { 'missing-fields' } },
--             },
--         },
--     },
--     -- Define dartls configuration here as well, if it has any specific settings
--     dartls = {
--         mason = false,
--         cmd = { "dart", 'language-server', '--protocol=lsp' },
--         root_pattern = { 'pubspec.yaml' },
--     },
-- }


-- comment out what language server you want to use
return {
    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },
    -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
    -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.omnisharp" },
    { import = "lazyvim.plugins.extras.lang.angular" },

    { import = "lazyvim.plugins.extras.lang.markdown" },


    -- add any tools you want to have installed below
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "flake8",
            },
        },
    },

    -- add tsserver and setup with typescript.nvim instead of lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/typescript.nvim",
            init = function()
                require("lazyvim.util").lsp.on_attach(function(_, buffer)
                    -- stylua: ignore
                    vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports",
                        { buffer = buffer, desc = "Organize Imports" })
                    vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
                end)
            end,
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- tsserver will be automatically installed with mason and loaded with lspconfig
                tsserver = {},
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                tsserver = function(_, opts)
                    require("typescript").setup({ server = opts })
                    return true
                end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
    },
}
