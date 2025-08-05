-- plugins/which-key.lua
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout    = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        plugins = {
            marks     = true,
            registers = true,
            spelling  = { enabled = true, suggestions = 20 },
            presets   = {
                operators    = true,
                motions      = true,
                text_objects = true,
                windows      = true,
                nav          = true,
                z            = true,
                g            = true,
            },
        },

        operators = { gc = "Comments" },

        replace = {
            key = {
                { "<space>", "SPC" },
                { "<cr>",    "RET" },
                { "<tab>",   "TAB" },
            },
        },

        icons = {
            breadcrumb = "»",
            separator  = "➜",
            group      = "+",
        },

        keys = {
            scroll_down = "<c-d>",
            scroll_up   = "<c-u>",
        },

        win = {
            padding   = { 2, 2 },
            title     = true,
            title_pos = "center",
            zindex    = 1000,
        },

        layout = {
            height  = { min = 4, max = 25 },
            width   = { min = 20, max = 50 },
            spacing = 3,
            align   = "left",
        },

        sort = "desc", -- keep grouping order first, then alpha

        triggers = "auto",

        -- emulate your old triggers_blacklist
        defer = function(ctx)
            if ctx.mode == "i" or ctx.mode == "v" then
                return ctx.operator == "j" or ctx.operator == "k"
            end
            return false
        end,
    },

    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        -- new v3 mapping spec (list of specs)
        -- wk.add({
        --     { "<leader>f",  group = "+file" },
        --     { "<leader>fm", desc = "Format file" },

        --     { "<leader>s",  group = "+search" },
        --     { "<leader>sf", desc = "Find files" },
        --     { "<leader>sg", desc = "Live grep" },
        --     { "<leader>sb", desc = "Find buffers" },
        --     { "<leader>sh", desc = "Help tags" },
        --     { "<leader>sk", desc = "Keymaps" },
        --     { "<leader>sc", desc = "Commands" },
        --     { "<leader>sr", desc = "Recent files" },
        --     { "<leader>sw", desc = "Current word" },
        --     { "<leader>sd", desc = "Diagnostics" },
        --     { "<leader>ss", desc = "Search in buffer" },

        --     { "<leader>l",  group = "+lsp" },
        --     { "<leader>lr", desc = "References" },
        --     { "<leader>ld", desc = "Definitions" },
        --     { "<leader>li", desc = "Implementations" },
        --     { "<leader>ls", desc = "Document symbols" },
        --     { "<leader>lw", desc = "Workspace symbols" },

        --     { "<leader>g",  group = "+git" },
        --     { "<leader>gf", desc = "Git files" },
        --     { "<leader>gc", desc = "Git commits" },
        --     { "<leader>gb", desc = "Git branches" },
        --     { "<leader>gs", desc = "Git status" },
        --     { "<leader>ge", desc = "Git explorer" },

        --     { "<leader>h",  group = "+harpoon" },
        --     { "<leader>hc", desc = "Clear all marks" },
        --     { "<leader>hr", desc = "Remove current file" },
        --     { "<leader>h1", hidden = true },
        --     { "<leader>h2", hidden = true },
        --     { "<leader>h3", hidden = true },
        --     { "<leader>h4", hidden = true },
        --     { "<leader>h5", hidden = true },

        --     { "<leader>e",  desc = "Explorer NeoTree" },
        --     { "<leader>E",  desc = "Explorer NeoTree (float)" },

        --     { "<leader>b",  group = "+buffer" },
        --     { "<leader>be", desc = "Buffer explorer" },

        --     { "<leader>u",  desc = "Undo tree" },

        --     { "<leader>r",  group = "+rename/refactor" },
        --     { "<leader>rn", desc = "Rename symbol" },

        --     { "<leader>c",  group = "+code" },
        --     { "<leader>ca", desc = "Code action" },

        --     { "<leader>D",  desc = "Type definition" },
        --     { "<leader>?",  desc = "Help which-key" },
        -- }, { prefix = "<leader>" })

        -- wk.add({
        --     { "g",  group = "+goto" },
        --     { "gd", desc = "Go to definition" },
        --     { "gD", desc = "Go to declaration" },
        --     { "gr", desc = "Go to references" },
        --     { "gi", desc = "Go to implementation" },
        -- })

        -- wk.add({
        --     { "[",  group = "+prev" },
        --     { "[f", desc = "Previous function" },
        --     { "[c", desc = "Previous class" },
        --     { "[a", desc = "Previous parameter" },
        --     { "[F", desc = "Previous function end" },
        --     { "[C", desc = "Previous class end" },
        --     { "[A", desc = "Previous parameter end" },
        --     { "[t", desc = "Previous todo comment" },
        -- })

        -- wk.add({
        --     { "]",  group = "+next" },
        --     { "]f", desc = "Next function" },
        --     { "]c", desc = "Next class" },
        --     { "]a", desc = "Next parameter" },
        --     { "]F", desc = "Next function end" },
        --     { "]C", desc = "Next class end" },
        --     { "]A", desc = "Next parameter end" },
        --     { "]t", desc = "Next todo comment" },
        -- })
    end,
}
