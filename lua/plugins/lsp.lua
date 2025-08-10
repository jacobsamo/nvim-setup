-- Enhanced LSP Configuration with First-Class Language Support
-- File: lua/config/lsp.lua

local M = {}

-- Core LSP servers configuration
-- These are lightweight servers that load for all supported file types
---@type table<string, table>
local core_servers = {
    -- Web Development
    html = {
        filetypes = { 'html', 'htmldjango', 'templ' },
        settings = {
            html = {
                format = {
                    templating = true,
                    wrapLineLength = 120,
                    wrapAttributes = 'auto',
                },
                hover = {
                    documentation = true,
                    references = true,
                },
            },
        },
    },
    cssls = {
        settings = {
            css = {
                validate = true,
                lint = {
                    unknownAtRules = "ignore",
                },
            },
            scss = {
                validate = true,
                lint = {
                    unknownAtRules = "ignore",
                },
            },
            less = {
                validate = true,
                lint = {
                    unknownAtRules = "ignore",
                },
            },
        },
    },
    -- jsonls = {
    --     settings = {
    --         json = {
    --             schemas = require('schemastore').json.schemas({
    --                 select = {
    --                     '.eslintrc',
    --                     'package.json',
    --                     'tsconfig.json',
    --                     'jsconfig.json',
    --                 },
    --             }),
    --             validate = { enable = true },
    --         },
    --     },
    -- },
    -- yamlls = {
    --     settings = {
    --         yaml = {
    --             schemaStore = {
    --                 enable = false,
    --                 url = "",
    --             },
    --             schemas = require('schemastore').yaml.schemas({
    --                 select = {
    --                     'docker-compose.yml',
    --                     'GitHub Workflow',
    --                     'GitLab CI',
    --                 },
    --             }),
    --             format = {
    --                 enable = true,
    --             },
    --             validate = true,
    --             completion = true,
    --         },
    --     },
    -- },
    marksman = {
        filetypes = { 'markdown', 'markdown.mdx' },
        settings = {
            marksman = {
                completion = {
                    wiki = {
                        style = "title",
                    },
                },
            },
        },
    },
    eslint = {
        settings = {
            workingDirectories = { mode = "auto" },
            format = { enable = true },
            lint = { enable = true },
        },
        on_attach = function(client, bufnr)
            -- Enable ESLint formatting
            client.server_capabilities.documentFormattingProvider = true
        end,
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim', 'require', 'pcall', 'pairs', 'ipairs' },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
                completion = {
                    callSnippet = 'Replace',
                },
                telemetry = {
                    enable = false,
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "2",
                    },
                },
            },
        },
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "basic",
                },
            },
        },
    },
}

-- First-class language configurations
-- These are feature-rich setups for primary development languages
local first_class_langs = {
    typescript = {
        filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        lazy_load = true,
        servers = {
            ts_ls = {
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                        suggest = {
                            includeCompletionsForModuleExports = true,
                        },
                        preferences = {
                            importModuleSpecifier = "relative",
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                        suggest = {
                            includeCompletionsForModuleExports = true,
                        },
                    },
                },
            },
            tailwindcss = {
                filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                "tw`([^`]*)",
                                "tw=\"([^\"]*)",
                                "tw={'([^'}]*)",
                                "tw\\.\\w+`([^`]*)",
                                "tw\\(.*?\\)`([^`]*)",
                                "class\\s*=\\s*[\"']([^\"']*)[\"']",
                                "className\\s*=\\s*[\"']([^\"']*)[\"']",
                            },
                        },
                        validate = true,
                        lint = {
                            cssConflict = "warning",
                            invalidApply = "error",
                            invalidScreen = "error",
                            invalidVariant = "error",
                            invalidConfigPath = "error",
                            invalidTailwindDirective = "error",
                        },
                    },
                },
            },
        },
        plugins = {
            {
                "pmizio/typescript-tools.nvim",
                dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
                opts = {
                    on_attach = function(client, bufnr)
                        -- Disable formatting in favor of prettier/eslint
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false

                        local function map(mode, lhs, rhs, desc)
                            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
                        end

                        -- TypeScript-specific commands
                        map("n", "<leader>co", "<cmd>TSToolsOrganizeImports<cr>", "[C]ode: [O]rganize Imports")
                        map("n", "<leader>cm", "<cmd>TSToolsAddMissingImports<cr>", "[C]ode: Add [M]issing Imports")
                        map("n", "<leader>cu", "<cmd>TSToolsRemoveUnused<cr>", "[C]ode: Remove [U]nused")
                        map("n", "<leader>cF", "<cmd>TSToolsFixAll<cr>", "[C]ode: [F]ix All")
                        map("n", "<leader>cR", "<cmd>TSToolsRenameFile<cr>", "[C]ode: [R]ename File")
                        map("n", "<leader>cS", "<cmd>TSToolsSelectTSVersion<cr>", "[C]ode: [S]elect TS Version")
                        map("n", "<leader>cI", "<cmd>TSToolsGoToSourceDefinition<cr>", "[C]ode: Go to Source Definition")
                    end,
                    settings = {
                        separate_diagnostic_server = true,
                        publish_diagnostic_on = "insert_leave",
                        tsserver_max_memory = "auto",
                        complete_function_calls = false,
                        include_completions_with_insert_text = true,
                        tsserver_file_preferences = {
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
            },
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
                config = function()
                    require("nvim-ts-autotag").setup({
                        opts = {
                            enable_close = true,
                            enable_rename = true,
                            enable_close_on_slash = false,
                        },
                        per_filetype = {
                            ["html"] = { enable_close = false },
                        },
                    })
                end,
            },
            {
                "folke/ts-comments.nvim",
                event = "VeryLazy",
                opts = {},
            },
        },
    },
    angular = {
        filetypes = { 'html', 'typescript' },
        lazy_load = true,
        servers = {
            angularls = {
                filetypes = { 'typescript', 'html' },
                root_dir = function(fname)
                    local util = require('lspconfig.util')
                    return util.root_pattern('angular.json', 'project.json')(fname)
                end,
            },
        },
        plugins = {
            {
                "joeveiga/ng.nvim",
                ft = { "typescript", "html"},
                config = function()
                    require("ng").setup({})
                end,
            },
        },
    },
    csharp = {
        filetypes = { 'cs', 'csproj', 'sln', 'slnx' },
        lazy_load = true,
        servers = {
            omnisharp = {
                mason = false,
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                settings = {
                    FormattingOptions = {
                        EnableEditorConfigSupport = true,
                        OrganizeImports = true,
                    },
                    MsBuild = {
                        LoadProjectsOnDemand = false,
                    },
                    RoslynExtensionsOptions = {
                        EnableAnalyzersSupport = true,
                        EnableImportCompletion = true,
                        AnalyzeOpenDocumentsOnly = false,
                    },
                    Sdk = {
                        IncludePrereleases = true,
                    },
                },
                on_attach = function(client, bufnr)
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
                    end

                    -- C#-specific commands
                    map("n", "<leader>cR", "<cmd>OmniSharpRestartServer<cr>", "[C]# [R]estart Server")
                    map("n", "<leader>cG", "<cmd>OmniSharpGlobalCodeCheck<cr>", "[C]# [G]lobal Code Check")
                end,
            },
        },
        plugins = {
            {
                "Hoffs/omnisharp-extended-lsp.nvim",
                ft = { "cs" },
                config = function()
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
                    end

                    -- Enhanced C# LSP integration with snacks.nvim support
                    map("n", "gd", function()
                        -- Try snacks.nvim first, fallback to omnisharp-extended
                        if pcall(require, "snacks") then
                            local snacks = require("snacks")
                            if snacks.picker then
                                -- Use omnisharp extended data with snacks picker
                                require("omnisharp_extended").lsp_definitions({
                                    on_list = function(options)
                                        snacks.picker.qflist({ items = options.items, title = "Definitions" })
                                    end
                                })
                            else
                                vim.lsp.buf.definition()
                            end
                        else
                            vim.lsp.buf.definition()
                        end
                    end, "[G]o to [D]efinition")

                    map("n", "gr", function()
                        if pcall(require, "snacks") then
                            local snacks = require("snacks")
                            if snacks.picker then
                                require("omnisharp_extended").lsp_references({
                                    on_list = function(options)
                                        snacks.picker.qflist({ items = options.items, title = "References" })
                                    end
                                })
                            else
                                vim.lsp.buf.references()
                            end
                        else
                            vim.lsp.buf.references()
                        end
                    end, "[G]o to [R]eferences")

                    map("n", "gi", function()
                        if pcall(require, "snacks") then
                            local snacks = require("snacks")
                            if snacks.picker then
                                require("omnisharp_extended").lsp_implementations({
                                    on_list = function(options)
                                        snacks.picker.qflist({ items = options.items, title = "Implementations" })
                                    end
                                })
                            else
                                vim.lsp.buf.implementation()
                            end
                        else
                            vim.lsp.buf.implementation()
                        end
                    end, "[G]o to [I]mplementation")
                end,
            },
        },
    },
    dart = {
        filetypes = { 'dart' },
        lazy_load = true,
        servers = {
            dartls = {
                mason = false,
                cmd = { "dart", "language-server", "--protocol=lsp" },
                init_options = {
                    onlyAnalyzeProjectsWithOpenFiles = false,
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
        -- plugins = {
        --     {
        --         "akinsho/flutter-tools.nvim",
        --         ft = { "dart" },
        --         dependencies = {
        --             "nvim-lua/plenary.nvim",
        --             "stevearc/dressing.nvim",
        --         },
        --         config = function()
        --             require("flutter-tools").setup({
        --                 ui = {
        --                     border = "rounded",
        --                     notification_style = "native",
        --                 },
        --                 decorations = {
        --                     statusline = {
        --                         app_version = false,
        --                         device = true,
        --                     },
        --                 },
        --                 debugger = {
        --                     enabled = false,
        --                 },
        --                 flutter_path = nil,       -- Auto-detect
        --                 flutter_lookup_cmd = nil, -- Auto-detect
        --                 fvm = false,              -- Set to true if using FVM
        --                 widget_guides = {
        --                     enabled = false,
        --                 },
        --                 closing_tags = {
        --                     highlight = "Comment",
        --                     prefix = "// ",
        --                     enabled = true,
        --                 },
        --                 dev_log = {
        --                     enabled = true,
        --                     notify_errors = false,
        --                     open_cmd = "tabedit",
        --                 },
        --                 dev_tools = {
        --                     autostart = false,
        --                     auto_open_browser = false,
        --                 },
        --                 outline = {
        --                     open_cmd = "30vnew",
        --                     auto_open = false,
        --                 },
        --                 lsp = {
        --                     color = {
        --                         enabled = false,
        --                         background = false,
        --                         background_color = nil,
        --                         foreground = false,
        --                         virtual_text = true,
        --                         virtual_text_str = "■",
        --                     },
        --                     on_attach = function(client, bufnr)
        --                         local function map(mode, lhs, rhs, desc)
        --                             vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        --                         end

        --                         -- Flutter-specific commands
        --                         map("n", "<leader>fR", "<cmd>FlutterReload<cr>", "[F]lutter [R]eload")
        --                         map("n", "<leader>fT", "<cmd>FlutterRestart<cr>", "[F]lutter Res[T]art")
        --                         map("n", "<leader>fq", "<cmd>FlutterQuit<cr>", "[F]lutter [Q]uit")
        --                         map("n", "<leader>fd", "<cmd>FlutterDevices<cr>", "[F]lutter [D]evices")
        --                         map("n", "<leader>fe", "<cmd>FlutterEmulators<cr>", "[F]lutter [E]mulators")
        --                         map("n", "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", "[F]lutter [O]utline")
        --                         map("n", "<leader>ft", "<cmd>FlutterDevTools<cr>", "[F]lutter Dev[T]ools")
        --                         map("n", "<leader>fc", "<cmd>FlutterCopyProfilerUrl<cr>", "[F]lutter [C]opy Profiler URL")
        --                         map("n", "<leader>fl", "<cmd>FlutterLspRestart<cr>", "[F]lutter [L]SP Restart")
        --                     end,
        --                     capabilities = function()
        --                         local capabilities = vim.lsp.protocol.make_client_capabilities()
        --                         local has_blink, blink = pcall(require, "blink.cmp")
        --                         if has_blink then
        --                             capabilities = vim.tbl_deep_extend("force", capabilities,
        --                                 blink.get_lsp_capabilities())
        --                         end
        --                         return capabilities
        --                     end,
        --                 },
        --             })
        --         end,
        --     },
        -- },
    },
}

-- Additional LSP-related plugins
local additional_plugins = {
    "b0o/schemastore.nvim",
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            progress = {
                suppress_on_insert = false,
                ignore_done_already = false,
                ignore_empty_message = false,
                clear_on_detach = function(client_id)
                    local client = vim.lsp.get_client_by_id(client_id)
                    return client and client.name or nil
                end,
                notification_group = function(msg)
                    return msg.lsp_name
                end,
                ignore = {},
            },
            notification = {
                window = {
                    winblend = 100,
                    border = "none",
                    zindex = 45,
                    max_width = 0,
                    max_height = 0,
                },
            },
        },
    },
}

-- Helper functions
local function split_servers(servers_config)
    local mason = {}
    local manual = {}

    for name, config in pairs(servers_config) do
        if config.mason ~= false then
            table.insert(mason, name)
        else
            table.insert(manual, name)
        end
    end

    return mason, manual
end

local function setup_server(name, config, capabilities)
    config = vim.tbl_deep_extend("force", {}, config)
    config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

    -- Add default on_attach if not provided
    if not config.on_attach then
        config.on_attach = function(client, bufnr)
            -- Enable inlay hints if supported
            if client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
        end
    else
        local original_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
            -- Enable inlay hints
            if client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
            original_on_attach(client, bufnr)
        end
    end

    -- Remove custom keys
    config.mason = nil
    config.enable = nil

    local success, err = pcall(require("lspconfig")[name].setup, config)
    if not success then
        vim.notify("Failed to setup " .. name .. ": " .. err, vim.log.levels.ERROR)
    end
end

local function create_first_class_plugins()
    local plugins = {}

    for lang_name, lang_config in pairs(first_class_langs) do
        if lang_config.plugins then
            for _, plugin in ipairs(lang_config.plugins) do
                -- Add filetype loading if not already present
                if lang_config.lazy_load and not plugin.ft and not plugin.event then
                    plugin.ft = lang_config.filetypes
                end
                table.insert(plugins, plugin)
            end
        end
    end

    return plugins
end

local function setup_first_class_servers(capabilities)
    for lang_name, lang_config in pairs(first_class_langs) do
        if lang_config.servers then
            for server_name, server_config in pairs(lang_config.servers) do
                setup_server(server_name, server_config, capabilities)
            end
        end
    end
end

-- Main configuration
local function setup()
    -- Get capabilities from blink.cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_blink, blink = pcall(require, "blink.cmp")
    if has_blink then
        capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
    end

    -- Setup Mason
    require("mason").setup({
        ui = {
            border = "rounded",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })

    -- Split servers and install mason-managed ones
    local mason_servers, manual_servers = split_servers(core_servers)

    require("mason-tool-installer").setup({
        ensure_installed = mason_servers,
        auto_update = false,
        run_on_start = true,
    })

    require("mason-lspconfig").setup({
        ensure_installed = mason_servers,
        automatic_installation = true,
        handlers = {
            function(server_name)
                local config = core_servers[server_name] or {}
                setup_server(server_name, config, capabilities)
            end,
        },
    })

    -- Setup manual servers
    for _, server_name in ipairs(manual_servers) do
        local config = core_servers[server_name] or {}
        setup_server(server_name, config, capabilities)
    end

    -- Setup first-class language servers
    setup_first_class_servers(capabilities)

    -- Configure diagnostics
    vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
            source = "if_many",
            spacing = 2,
            prefix = "●",
            format = function(diagnostic)
                local max_width = 80
                local message = diagnostic.message
                if #message > max_width then
                    return message:sub(1, max_width) .. "..."
                end
                return message
            end,
        },
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
        signs = vim.g.have_nerd_font and {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚",
                [vim.diagnostic.severity.WARN] = "󰀪",
                [vim.diagnostic.severity.INFO] = "󰋽",
                [vim.diagnostic.severity.HINT] = "󰌶",
            },
        } or {
            text = {
                [vim.diagnostic.severity.ERROR] = "E",
                [vim.diagnostic.severity.WARN] = "W",
                [vim.diagnostic.severity.INFO] = "I",
                [vim.diagnostic.severity.HINT] = "H",
            },
        },
    })

    -- Customize LSP handlers
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = "rounded" }
    )

    require("lspconfig.ui.windows").default_options.border = "rounded"
end

-- Export for lazy.nvim
return vim.list_extend({
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "saghen/blink.cmp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "j-hui/fidget.nvim",
            "b0o/schemastore.nvim",
        },
        config = setup,
    },
}, vim.list_extend(create_first_class_plugins(), additional_plugins))
