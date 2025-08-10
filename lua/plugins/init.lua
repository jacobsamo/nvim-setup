return {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- Undotree - Visualize undo history easily
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
        },
        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_SplitWidth = 35
            vim.g.undotree_DiffpanelHeight = 15
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },

    -- a module to help you be good at Vim
    {
        "theprimeagen/vim-be-good",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        event = "VeryLazy",
        cmd = "VimBeGood",
        config = function()
        end

    }

}
