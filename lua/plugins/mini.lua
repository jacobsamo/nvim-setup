-- Mini.nvim configuration - collection of small independent plugins
return {
    {
        "echasnovski/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            -- Examples:
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()

            -- Comment out lines
            -- gc    - [G]lobal [C]omment
            -- gcc   - [G]lobal [C]omment [C]urrent line
            require("mini.comment").setup()

            -- Auto pairs for brackets, quotes, etc.
            require("mini.pairs").setup()

            -- Highlight patterns in text
            require("mini.hipatterns").setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex color strings (`#rrggbb`) with that color
                    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
                },
            })

            -- Simple and easy statusline
            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = vim.g.have_nerd_font })

            -- Customize statusline sections
            statusline.section_location = function()
                return "%2l:%-2v"
            end

            -- Move any selection in any direction
            require("mini.move").setup({
                mappings = {
                    -- Move visual selection in Visual mode
                    left = "<M-h>",
                    right = "<M-l>",
                    down = "<M-j>",
                    up = "<M-k>",

                    -- Move current line in Normal mode
                    line_left = "<M-h>",
                    line_right = "<M-l>",
                    line_down = "<M-j>",
                    line_up = "<M-k>",
                },
                options = {
                    reindent_linewise = true,
                },
            })

            -- Better text objects
            require("mini.indentscope").setup({
                symbol = "│",
                options = { try_as_border = true },
            })

            -- Extend and create a/i textobjects
            require("mini.extra").setup()

            -- Split and join arguments
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "gS",
                    split = "",
                    join = "",
                },
            })

            -- Operators to evaluate text and replace with output
            require("mini.operators").setup({
                evaluate = {
                    prefix = "g=",
                },
                exchange = {
                    prefix = "gx",
                },
                multiply = {
                    prefix = "gm",
                },
                replace = {
                    prefix = "gr",
                },
                sort = {
                    prefix = "gs",
                },
            })

            -- Animate common Neovim actions
            local animate = require("mini.animate")
            animate.setup({
                resize = {
                    timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
                },
                scroll = {
                    timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
                },
            })

            -- Files and directories manipulation
            require("mini.files").setup({
                mappings = {
                    close = "q",
                    go_in = "l",
                    go_in_plus = "L",
                    go_out = "h",
                    go_out_plus = "H",
                    reset = "<BS>",
                    reveal_cwd = "@",
                    show_help = "g?",
                    synchronize = "=",
                    trim_left = "<",
                    trim_right = ">",
                },
                options = {
                    permanent_delete = true,
                    use_as_default_explorer = false,
                },
            })

            -- Keymap for mini.files
            vim.keymap.set("n", "<leader>fm", function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
            end, { desc = "Open mini.files (directory of current file)" })

            vim.keymap.set("n", "<leader>fM", function()
                require("mini.files").open(vim.loop.cwd(), true)
            end, { desc = "Open mini.files (cwd)" })
        end,
    },
}
