-- tree sitter is a parser generator for programming languages
-- it is used to highlight code in the editor
-- it is used to provide syntax highlighting
-- it is used to provide code completion
-- it is used to provide code folding
-- it is used to provide formatting
return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "css",
            "dart",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
            "c_sharp",
        },
        indent = {
            enable = true,
        },
        highlight = {
            enable = true,
        },
    },
    build = ":TSUpdate",
}
