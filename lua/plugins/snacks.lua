-- Snacks.nvim configuration (file picker)
return
{
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
        {
            "<leader>sf",
            function()
                Snacks.picker.smart()
            end,
            desc = "[S]earch [F]ile",
        },
        {
            "<leader>sg",
            function()
                Snacks.picker.grep()
            end,
            desc = "[S]earch [G]rep",
        },
        { "<leader>.",   function() Snacks.scratch() end,          desc = "Toggle Scratch Buffer" },
        { "<leader>S",   function() Snacks.scratch.select() end,   desc = "Select Scratch Buffer" },
        { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
    },
    opts = {
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        words = { enabled = true },
        dashboard = {
            preset = {
                -- stylua: ignore
                ---@type snacks.dashboard.Item[]
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },
        -- terminal = {
        --     win = {
        --         keys = {
        --             nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
        --             nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
        --             nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
        --             nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
        --         },
        --     },
        -- },
    },
}
