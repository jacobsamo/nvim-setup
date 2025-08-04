-- Conform setup
-- Conform is a formatter for nvim
-- https://github.com/stevearc/conform.nvim
return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    dependencies = { "mason.nvim" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                javascript = { "biome", "prettier" },
                typescript = { "biome", "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "biome", "prettier" },
                dart = { "dart_format" },
                csharp = { "csharpier" },
            },
            format_on_save = function(bufnr)
                local has_config = vim.fs.find(
                    { "biome.json", ".biome.json", ".prettierrc", ".prettierrc.json" },
                    {
                        upward = true,
                        path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
                        type = "file",
                        limit = 1,
                    }
                )
                return #has_config > 0
            end,
        })

        vim.keymap.set("n", "<leader>fm", function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, { desc = "Format File" })
    end,
}
