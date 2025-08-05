-- plugins/which-key.lua
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = false,
            },
        },
        layout = {
            height = { min = 4, max = 20 }, -- smaller height
            width = { min = 20, max = 50 }, -- smaller width
            spacing = 3,              -- space between columns
            align = "right",          -- align to right
        },
        window = {
            border = "rounded", -- optional: single/double/shadow
            margin = { 0, 0, 1, 1 }, -- top, right, bottom, left
            padding = { 1, 2, 1, 2 }, -- top, right, bottom, left
            winblend = 10,      -- transparency
            position = "right", -- position of the popup
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
        show_help = true,
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
}
