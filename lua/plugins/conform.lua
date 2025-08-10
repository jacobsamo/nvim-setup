return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                javascript = { "biome", "prettier" },
                typescript = { "biome", "prettier" },
                javascriptreact = { "biome", "prettier" },
                typescriptreact = { "biome", "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                json = { "biome", "prettier" },
                jsonc = { "biome", "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                dart = { "dart_format" },
                python = { "black", "isort" },
                lua = { "stylua" },
                csharp = { "csharpier" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end
}
