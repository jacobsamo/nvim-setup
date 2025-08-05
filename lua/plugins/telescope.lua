-- Telescope.nvim configuration
-- Telescope is a highly extendable fuzzy finder over lists.
return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                file_ignore_patterns = {
                    '.git/',
                    'node_modules/',
                },
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                },
            },
            extensions = {
                ["ui-select"] = require("telescope.themes").get_dropdown {
                    previewer = false, -- optional: cleaner dropdown
                },
            },
        })
    end,
}
