return {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
        { "\\",   "<cmd>Neotree focus<CR>", desc = "Focus NeoTree", silent = true },
        { "\\\\", "<cmd>Neotree close<CR>", desc = "Close NeoTree", silent = true },
    },
    opts = {
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
            },
        },
    },
}
