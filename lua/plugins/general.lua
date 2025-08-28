-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
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
