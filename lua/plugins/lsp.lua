---@alias LazyPluginSpec table

---@class ServerConfig
---@field server_name string
---@field mason? boolean
---@field server_config? table
---@field on_attach? fun(client, bufnr: integer)
---@field filetypes? string[]
---@field root_pattern? string[]
---@field plugins? LazyPluginSpec[]

---@type table<string, ServerConfig>
local servers = {
	typescript_javascript = {
		server_name = "ts_ls",
		root_pattern = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
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
		root_pattern = {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.ts",
			"postcss.config.js",
			".git",
		},
	},

	angular = {
		server_name = "angularls",
		filetypes = { "html", "typescript" },
		root_pattern = { "angular.json", "package.json", ".git" },
	},

	dart = {
		server_name = "dartls",
		mason = false,
		root_pattern = { "pubspec.yaml", ".git" },
	},

	lua = {
		server_name = "lua_ls",
		root_pattern = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", ".git" },
	},

	json = {
		server_name = "jsonls",
		root_pattern = { "package.json", ".git" },
	},

	csharp = {
		server_name = "omnisharp",
		root_pattern = { "*.sln", "*.csproj", ".git" },
	},

	python = {
		server_name = "pyright",
		root_pattern = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
	},

	go = {
		server_name = "gopls",
		root_pattern = { "go.mod", ".git" },
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

				-- Always resolve root_dir from each server's pattern
				local root_dir = cfg.root_pattern and util.root_pattern(unpack(cfg.root_pattern))
					or util.root_pattern(".git")

				local opts = {
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						global_on_attach(client, bufnr)
						if cfg.on_attach then
							cfg.on_attach(client, bufnr)
						end
					end,
					filetypes = cfg.filetypes,
					root_dir = root_dir,
				}

				if cfg.server_config then
					opts = vim.tbl_deep_extend("force", opts, cfg.server_config)
				end

				lspconfig[cfg.server_name].setup(opts)
			end
		end,
	},
}
