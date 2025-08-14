---@alias LazyPluginSpec table

---@class ServerConfig
---@field server_name string
---@field mason? boolean
---@field server_config? table
---@field on_attach? fun(client, bufnr: integer)
---@field filetypes? string[]
---@field plugins? LazyPluginSpec[]

---@type table<string, ServerConfig>
local servers = {
	typescript_javascript = {
		server_name = "ts_ls",
		plugins = {
			{
				"pmizio/typescript-tools.nvim",
				dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
				event = "InsertEnter",
				opts = {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
						local map = function(mode, lhs, rhs, desc)
							vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
						end
						map("n", "<leader>co", "<cmd>TSToolsOrganizeImports<cr>", "[C]ode: [O]rganize Imports")
						map("n", "<leader>cm", "<cmd>TSToolsAddMissingImports<cr>", "[C]ode: Add [M]issing Imports")
						map("n", "<leader>cu", "<cmd>TSToolsRemoveUnused<cr>", "[C]ode: Remove [U]nused")
					end,
					settings = { complete_function_calls = false },
				},
			},
			{ "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
		},
	},

	tailwind = {
		server_name = "tailwindcss",
	},

	angular = {
		server_name = "angularls",
		filetypes = { 'typescript', 'html', 'htmlangular' },
	},

	dart = {
		server_name = "dartls",
		mason = false,
	},

	lua = {
		server_name = "lua_ls",
	},

	csharp = {
		server_name = "omnisharp",
	},

	python = {
		server_name = "pyright",
	},

	go = {
		server_name = "gopls",
	},

  	json = {
		server_name = "jsonls",
	},

  yaml = {
    server_name = "yamlls"
  },

  html = {
    server_name = "html"
  },

  css = {
    server_name = "cssls"
  },
}

local function getPlugins()
	local all_plugins = {}
	for _, server in pairs(servers) do
		if server.plugins then
			for _, plugin in ipairs(server.plugins) do
				table.insert(all_plugins, plugin)
			end
		end
	end
	return all_plugins
end

return {
	getPlugins(),

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"j-hui/fidget.nvim",
			"b0o/schemastore.nvim",
			getPlugins(),
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local util = require("lspconfig.util")
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("fidget").setup()

			mason.setup()

			-- Collect all servers that should be installed by mason
			local mason_servers = {}
			for _, cfg in pairs(servers) do
				if cfg.mason ~= false then
					table.insert(mason_servers, cfg.server_name)
				end
			end

			mason_lspconfig.setup({
				ensure_installed = mason_servers,
			})

			local function global_on_attach(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end

			for _, cfg in pairs(servers) do
				if cfg.plugins then
					for _, plugin in ipairs(cfg.plugins) do
						require("lazy").setup({ plugin })
					end
				end

				local opts = {
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						global_on_attach(client, bufnr)
						if cfg.on_attach then
							cfg.on_attach(client, bufnr)
						end
					end,
					filetypes = cfg.filetypes,
				}

				if cfg.server_config then
					opts = vim.tbl_deep_extend("force", opts, cfg.server_config)
				end

				lspconfig[cfg.server_name].setup(opts)
			end
		end,
	},
}
