-- LazyVim LSP configuration bypassing vtsls completely
return {
  -- Configure nvim-lspconfig with reliable TypeScript setup
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable all problematic servers
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          enabled = false, -- Completely disable vtsls since it keeps failing
        },
        
        -- Use typescript-language-server as primary TypeScript server
        -- This is more reliable and widely supported
        typescript_language_server = {
          enabled = true,
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                includeInlayParameterNameHints = "literals",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
          -- Add essential TypeScript keybindings that work with typescript-language-server
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.addMissingImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.fixAll" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Fix all diagnostics",
            },
          },
        },
        
        -- Angular Language Server
        angularls = {
          filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        },
        
        -- HTML/CSS/JSON servers that work reliably
        html = {},
        cssls = {},
        jsonls = {},
        eslint = {},
        
        -- Dart/Flutter LSP
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
        -- Disable problematic servers
        tsserver = function()
          return true -- Disable
        end,
        ts_ls = function()
          return true -- Disable
        end,
        vtsls = function()
          return true -- Disable completely
        end,
        
        -- Setup typescript-language-server
        typescript_language_server = function(_, opts)
          require("lspconfig").tsserver.setup(opts) -- tsserver is the actual config name for typescript-language-server
          return true
        end,
        
        -- Setup Angular with proper integration
        angularls = function(_, opts)
          -- Setup Angular language server
          require("lspconfig").angularls.setup(opts)
          
          LazyVim.lsp.on_attach(function(client)
            -- Disable angular renaming capability due to duplicate rename popping up
            client.server_capabilities.renameProvider = false
          end, "angularls")
          return true
        end,
        
        dartls = function(_, opts)
          require("lspconfig").dartls.setup(opts)
          return true
        end,
      },
    },
  },

  -- Mason configuration - only install what actually works
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- Only include tools that work reliably
      local reliable_tools = {
        -- Language servers that work
        "typescript-language-server", -- This actually works
        "angular-language-server",
        "lua-language-server",
        "html-lsp",
        "css-lsp", 
        "json-lsp",
        "eslint-lsp",
        "pyright",
        
        -- Formatters that work
        "stylua",
        "prettier",
        "biome",
        "shellcheck",
        "shfmt",
        "flake8",
        
        -- Debug adapters that work
        "js-debug-adapter",
        "netcoredbg",
        
        -- Tools that work
        "eslint_d",
        "markdown-toc",
        "marksman",
      }
      
      -- Add all reliable tools
      vim.list_extend(opts.ensure_installed, reliable_tools)
      
      -- Explicitly exclude problematic packages
      -- Remove any existing problematic entries
      for i = #opts.ensure_installed, 1, -1 do
        local tool = opts.ensure_installed[i]
        if tool == "vtsls" or tool == "markdownlint-cli2" or tool == "csharpier" then
          table.remove(opts.ensure_installed, i)
        end
      end
    end,
  },

  -- Treesitter configuration for Angular and TypeScript
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "angular", "scss", "typescript", "tsx" })
      end
      
      -- Setup Angular file detection
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },

  -- Configure conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      
      -- JavaScript/TypeScript formatting with working tools
      local js_formatters = { "prettier" } -- Start with prettier only, add biome if working
      opts.formatters_by_ft.javascript = js_formatters
      opts.formatters_by_ft.typescript = js_formatters
      opts.formatters_by_ft.javascriptreact = js_formatters
      opts.formatters_by_ft.typescriptreact = js_formatters
      opts.formatters_by_ft.json = js_formatters
      opts.formatters_by_ft.html = { "prettier" }
      opts.formatters_by_ft.css = { "prettier" }
      opts.formatters_by_ft.scss = { "prettier" }
      opts.formatters_by_ft.htmlangular = { "prettier" }
      opts.formatters_by_ft.dart = { "dart_format" }
      opts.formatters_by_ft.lua = { "stylua" }
      opts.formatters_by_ft.sh = { "shfmt" }
      opts.formatters_by_ft.bash = { "shfmt" }
      
      opts.formatters = opts.formatters or {}
      opts.formatters.dart_format = {
        command = "dart",
        args = { "format", "--stdin-name", "$FILENAME" },
        stdin = true,
      }
      
      return opts
    end,
  },

  -- Configure nvim-lint for linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "flake8" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },

  -- Mini icons configuration
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },

  -- Add TypeScript support through extras but override the vtsls part
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Make sure we're not importing the typescript extra that forces vtsls
      opts.extras = opts.extras or {}
      -- Remove any typescript extra that might force vtsls
      for i = #opts.extras, 1, -1 do
        if opts.extras[i]:match("typescript") then
          table.remove(opts.extras, i)
        end
      end
    end,
  },
}