-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- formatters
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>sf", function() Snacks.picker.smart() end,    desc = "[S]earch [F]ile" },
      { "<leader>sg", function() Snacks.picker.grep() end,     desc = "[S]earch [G]rep" },
      { "\\",         function() Snacks.explorer.reveal() end, desc = "File Explorer" },
      { "\\\\",         function() Snacks.explorer() end, desc = "Toggle Explorer" },
    
    },
    opts = {
      explorer = {
        replace_netrw = true,
      },
      picker = {
        explorer = {

          win = {
            list = {
              keys = {
                ["\\"] = "explorer_close",
              },
            },
          },
        }
      }
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
