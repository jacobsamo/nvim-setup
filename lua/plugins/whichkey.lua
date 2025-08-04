-- Which-key configuration for hotkey support
return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            local wk = require("which-key")

            wk.setup({
                plugins = {
                    marks = true,
                    registers = true,
                    spelling = {
                        enabled = true,
                        suggestions = 20,
                    },
                    presets = {
                        operators = true,
                        motions = true,
                        text_objects = true,
                        windows = true,
                        nav = true,
                        z = true,
                        g = true,
                    },
                },
                operators = { gc = "Comments" },
                key_labels = {
                    ["<space>"] = "SPC",
                    ["<cr>"] = "RET",
                    ["<tab>"] = "TAB",
                },
                icons = {
                    breadcrumb = "»",
                    separator = "➜",
                    group = "+",
                },
                popup_mappings = {
                    scroll_down = "<c-d>",
                    scroll_up = "<c-u>",
                },
                window = {
                    border = "rounded",
                    position = "bottom",
                    margin = { 1, 0, 1, 0 },
                    padding = { 2, 2, 2, 2 },
                    winblend = 0,
                },
                layout = {
                    height = { min = 4, max = 25 },
                    width = { min = 20, max = 50 },
                    spacing = 3,
                    align = "left",
                },
                ignore_missing = true,
                hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
                show_help = true,
                show_keys = true,
                triggers = "auto",
                triggers_blacklist = {
                    i = { "j", "k" },
                    v = { "j", "k" },
                },
            })

            -- Register key mappings with descriptions
            wk.register({
                ["<leader>"] = {
                    f = {
                        name = "+file",
                        m = "Format file",
                    },
                    s = {
                        name = "+search",
                        f = "Find files",
                        g = "Live grep",
                        b = "Find buffers",
                        h = "Help tags",
                        k = "Keymaps",
                        c = "Commands",
                        r = "Recent files",
                        w = "Current word",
                        d = "Diagnostics",
                        s = "Search in buffer",
                    },
                    l = {
                        name = "+lsp",
                        r = "References",
                        d = "Definitions",
                        i = "Implementations",
                        s = "Document symbols",
                        w = "Workspace symbols",
                    },
                    g = {
                        name = "+git",
                        f = "Git files",
                        c = "Git commits",
                        b = "Git branches",
                        s = "Git status",
                        e = "Git explorer",
                    },
                    h = {
                        name = "+harpoon",
                        [1] = "which_key_ignore", -- Hide the number keys
                        [2] = "which_key_ignore",
                        [3] = "which_key_ignore",
                        [4] = "which_key_ignore",
                        [5] = "which_key_ignore",
                        c = "Clear all marks",
                        r = "Remove current file",
                    },
                    e = "Explorer NeoTree",
                    E = "Explorer NeoTree (float)",
                    b = {
                        name = "+buffer",
                        e = "Buffer explorer",
                    },
                    u = "Undo tree",
                    r = {
                        name = "+rename/refactor",
                        n = "Rename symbol",
                    },
                    c = {
                        name = "+code",
                        a = "Code action",
                    },
                    D = "Type definition",
                    ["?"] = "Help which-key",
                },
                g = {
                    name = "+goto",
                    d = "Go to definition",
                    D = "Go to declaration",
                    r = "Go to references",
                    i = "Go to implementation",
                },
                ["["] = {
                    name = "+prev",
                    f = "Previous function",
                    c = "Previous class",
                    a = "Previous parameter",
                    F = "Previous function end",
                    C = "Previous class end",
                    A = "Previous parameter end",
                    t = "Previous todo comment",
                },
                ["]"] = {
                    name = "+next",
                    f = "Next function",
                    c = "Next class",
                    a = "Next parameter",
                    F = "Next function end",
                    C = "Next class end",
                    A = "Next parameter end",
                    t = "Next todo comment",
                },
            })
        end,
    },
}
