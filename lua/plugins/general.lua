-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- Neo-tree configuration
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "\\", "<cmd>Neotree focus<CR>", desc = "Focus NeoTree", silent = true },
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
  },

  -- Snacks.nvim configuration (file picker)
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

  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "yaml",
        "dart", -- Add Dart support
        "c_sharp", -- Add C# support
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    },
  },

  -- Auto-tag for HTML/JSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}