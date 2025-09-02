-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
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
  {
    "ThePrimeagen/vim-be-good",
    event = "VeryLazy",
    config = function()
      require("vim-be-good").setup()
    end,
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
      {
        "\\",
        function()
          local snacks = Snacks.picker.get({ source = "explorer" })[1]
          if snacks then
            Snacks.picker.actions.focus_list(snacks)
          else
            Snacks.explorer({ focus = "list" })
          end
        end,
        desc = "Focus Explorer",
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
