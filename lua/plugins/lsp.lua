-- LazyVim LSP configuration with proper server setup
return {
  -- Language extras - these handle most of the setup automatically
  -- Configure nvim-lspconfig for additional servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- HTML/CSS/JSON servers (from vscode-langservers-extracted)
        html = {},
        cssls = {},
        jsonls = {},
        eslint = {},
        vtsls = {},
        
        -- Dart/Flutter LSP (not available through Mason)
        dartls = {
          cmd = { "dart", "language-server", "--protocol=lsp" },
          filetypes = { "dart" },
          init_options = {
            onlyAnalyzeProjectsWithOpenFiles = true,
            suggestFromUnimportedLibraries = true,
            closingLabels = true,
            outline = true,
            flutterOutline = true,
          },
          settings = {
            dart = {
              completeFunctionCalls = true,
              showTodos = true,
            },
          },
        },
      },
      setup = {
        -- Special setup for dartls since it's not managed by Mason
        dartls = function(_, opts)
          require("lspconfig").dartls.setup(opts)
          return true
        end,
      },
    },
  },

  -- Mason configuration for tools that can be auto-installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Formatters and linters
        "stylua",
        "prettier",
        "eslint_d",
        "shellcheck",
        "shfmt",
        "flake8",
        -- Biome for JS/TS formatting and linting
        "biome",
        "prettier"
      },
    },
  },

  -- Configure conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "biome", "prettier" },
        typescript = { "biome", "prettier" },
        javascriptreact = { "biome", "prettier" },
        typescriptreact = { "biome", "prettier" },
        json = { "biome", "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        dart = { "dart_format" },
        lua = { "stylua" },
      },
      formatters = {
        dart_format = {
          command = "dart",
          args = { "format", "--stdin-name", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },

  -- Configure nvim-lint for additional linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
  },
}