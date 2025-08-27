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
		filetypes = { 'typescript', 'html', 'htmlangular', 'typescriptreact' },
		server_config = {
			root_dir = function(fname)
				local util = require("lspconfig.util")
				return util.root_pattern("angular.json", "project.json", "nx.json")(fname)
					or util.root_pattern("package.json")(fname)
			end,
			on_new_config = function(new_config, new_root_dir)
				local util = require("lspconfig.util")
				new_config.cmd = {
					"ngserver",
					"--stdio",
					"--tsProbeLocations",
					new_root_dir,
					"--ngProbeLocations",
					new_root_dir,
				}
			end,
			settings = {
				angular = {
					enable = true,
					log = "verbose",
					forceStrictTemplates = false,
				}
			},
			init_options = {
				angular = {
					enable = true,
				}
			}
		}
	},

	dart = {
		server_name = "dartls",
		mason = false,
	},

	lua = {
		server_name = "lua_ls",
		server_config = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace"
					}
				}
			}
		}
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
		-- server_config = {
		-- 	settings = {
		-- 		json = {
		-- 			schemas = require('schemastore').json.schemas(),
		-- 			validate = { enable = true },
		-- 		}
		-- 	}
		-- }
	},

	yaml = {
		server_name = "yamlls",
		-- server_config = {
		-- 	settings = {
		-- 		yaml = {
		-- 			schemaStore = {
		-- 				enable = false,
		-- 				url = "",
		-- 			},
		-- 			schemas = require('schemastore').yaml.schemas(),
		-- 		}
		-- 	}
		-- }
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
	-- First, return all the plugins from servers
	unpack(getPlugins()),

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
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Setup fidget first
			require("fidget").setup()

			-- Setup mason
			mason.setup()

			-- Collect all servers that should be installed by mason
			local mason_servers = {}
			for _, cfg in pairs(servers) do
				if cfg.mason ~= false then
					table.insert(mason_servers, cfg.server_name)
				end
			end

			-- Setup mason-lspconfig with proper handlers
			mason_lspconfig.setup({
				ensure_installed = mason_servers,
				automatic_installation = true,
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

			-- Setup each server
			for _, cfg in pairs(servers) do
				local opts = {
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						global_on_attach(client, bufnr)
						if cfg.on_attach then
							cfg.on_attach(client, bufnr)
						end
					end,
				}

				-- Add filetypes if specified
				if cfg.filetypes then
					opts.filetypes = cfg.filetypes
				end

				-- Merge server_config if provided
				if cfg.server_config then
					opts = vim.tbl_deep_extend("force", opts, cfg.server_config)
				end

				-- Setup the server
				lspconfig[cfg.server_name].setup(opts)

				vim.diagnostic.config({
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = " ",
							[vim.diagnostic.severity.WARN] = " ",
							[vim.diagnostic.severity.HINT] = "󰠠 ",
							[vim.diagnostic.severity.INFO] = " ",
						},
					},
				})
			end
		end,
	},
}
