-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- formatters
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  { import = "lazyvim.plugins.extras.editor.neo-tree" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "\\", "<cmd>Neotree focus<CR>", desc = "Focus NeoTree", silent = true },
      { "\\\\", "<cmd>Neotree close<CR>", desc = "Close NeoTree", silent = true },
    },
  },

  {
    "folke/snacks.nvim",
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
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
}
