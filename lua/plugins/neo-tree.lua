-- using neo-tree over the snacks.nvim explorer module as we can't quite customise it to our liking
return {

    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "\\",         "<cmd>Neotree reveal<CR>",       desc = "NeoTree reveal",              silent = true },
        { "<leader>e",  "<cmd>Neotree toggle<CR>",       desc = "Explorer NeoTree (root dir)", silent = true },
        { "<leader>E",  "<cmd>Neotree toggle float<CR>", desc = "Explorer NeoTree (float)",    silent = true },
        { "<leader>ge", "<cmd>Neotree git_status<CR>",   desc = "Git explorer",                silent = true },
        { "<leader>be", "<cmd>Neotree buffers<CR>",      desc = "Buffer explorer",             silent = true },
    },
    opts = {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                },
                never_show = {},
            },
        },
        window = {
            mappings = {
                ["<space>"] = "none",
                ["Y"] = {
                    function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                    desc = "Copy Path to Clipboard",
                },
                ["O"] = {
                    function(state)
                        require("lazy.util").open(state.tree:get_node().path, { system = true })
                    end,
                    desc = "Open with System Application",
                },
                ["P"] = { "toggle_preview", config = { use_float = false } },
            },
        },
        default_component_configs = {
            indent = {
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            git_status = {
                symbols = {
                    added = "",
                    modified = "",
                    deleted = "✖",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },
        },
    },
}
