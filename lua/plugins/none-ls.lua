return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- Do not add formatters here this is handled by conform.nvim
                null_ls.builtins.diagnostics.flake8,
                null_ls.builtins.completion.spell,
                -- Add back in eslint if you choose to not use the lsp version
                -- null_ls.builtins.diagnostics.eslint_d,
                -- null_ls.builtins.code_actions.eslint_d,
            },
        })
    end,
}
