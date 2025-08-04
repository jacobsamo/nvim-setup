-- Formatting and Linting Configuration
return {
  -- Conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "biome", "prettier" },
          typescript = { "biome", "prettier" },
          javascriptreact = { "biome", "prettier" },
          typescriptreact = { "biome", "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "biome", "prettier" },
          jsonc = { "biome", "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          dart = { "dart_format" },
          python = { "black", "isort" },
          lua = { "stylua" },
          csharp = { "csharpier" },
        },
        
        -- Format on save with config file detection
        format_on_save = function(bufnr)
          -- Check for project-specific formatter configs
          local has_config = vim.fs.find(
            { 
              "biome.json", 
              ".biome.json", 
              "biome.jsonc",
              ".prettierrc", 
              ".prettierrc.json", 
              ".prettierrc.js",
              "prettier.config.js",
              "package.json" -- Check if prettier config is in package.json
            },
            {
              upward = true,
              path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
              type = "file",
              limit = 1,
            }
          )
          
          -- Only format if we have a config file or it's a specific filetype that should always be formatted
          local always_format_ft = { "lua", "python", "dart", "csharp" }
          local ft = vim.bo[bufnr].filetype
          
          if #has_config > 0 or vim.tbl_contains(always_format_ft, ft) then
            return {
              timeout_ms = 500,
              lsp_fallback = true,
            }
          end
        end,
        
        -- Configure specific formatters
        formatters = {
          biome = {
            condition = function(self, ctx)
              return vim.fs.find({ "biome.json", ".biome.json" }, { path = ctx.filename, upward = true })[1]
            end,
          },
          prettier = {
            condition = function(self, ctx)
              return vim.fs.find({ 
                ".prettierrc", 
                ".prettierrc.json", 
                ".prettierrc.js",
                "prettier.config.js"
              }, { path = ctx.filename, upward = true })[1]
            end,
          },
        },
      })

      -- Manual format keymap
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })

      -- Format command
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end,
  },

  -- Mason tool installer for formatters and linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier",
          "biome",
          "black",      -- Python formatter
          "isort",      -- Python import sorter
          "stylua",     -- Lua formatter
          "csharpier",  -- C# formatter
          
          -- Linters
          "eslint_d",   -- ESLint daemon
          "pylint",     -- Python linter
          "flake8",     -- Python linter
          "luacheck",   -- Lua linter
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- nvim-lint for linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "pylint" },
        lua = { "luacheck" },
      }

      -- Create autocommand for linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if there's a linter configured and config files exist
          local ft = vim.bo.filetype
          if lint.linters_by_ft[ft] then
            -- Check for ESLint config for JS/TS files
            if vim.tbl_contains({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, ft) then
              local has_eslint_config = vim.fs.find({
                ".eslintrc.js",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                "eslint.config.js",
                "package.json" -- Check if eslint config is in package.json
              }, { upward = true, type = "file" })[1]
              
              if has_eslint_config then
                lint.try_lint()
              end
            else
              lint.try_lint()
            end
          end
        end,
      })

      -- Manual lint keymap
      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
}