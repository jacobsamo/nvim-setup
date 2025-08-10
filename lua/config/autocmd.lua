-- Create augroup for LSP keymaps
local augroup = vim.api.nvim_create_augroup
local JacobSamoGroup = augroup('JacobSamo', { clear = true })

local autocmd = vim.api.nvim_create_autocmd

-- Enhanced LSP attach autocmd with comprehensive keybinds
autocmd('LspAttach', {
    group = JacobSamoGroup,
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        local bufnr = e.buf

        -- Helper function for setting keymaps with buffer-local scope
        local function map(mode, lhs, rhs, desc, additional_opts)
            local opts = { buffer = bufnr, desc = desc, silent = true }
            if additional_opts then
                opts = vim.tbl_extend("force", opts, additional_opts)
            end
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation mappings (most commonly used)
        map("n", "gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
        map("n", "gD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
        map("n", "gi", vim.lsp.buf.implementation, "[G]o to [I]mplementation")
        map("n", "gr", vim.lsp.buf.references, "[G]o to [R]eferences")
        map("n", "gt", vim.lsp.buf.type_definition, "[G]o to [T]ype Definition")
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

        -- Code actions and refactoring
        map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("v", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame Symbol")

        -- Diagnostics navigation
        map("n", "[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
        map("n", "<leader>e", vim.diagnostic.open_float, "Show [E]rror Details")
        map("n", "<leader>q", vim.diagnostic.setloclist, "Add Diagnostics to [Q]uickfix")

        -- Workspace management
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        -- Symbol search (prefers snacks.nvim, fallback to built-in)
        if pcall(require, "snacks") then
            local snacks = require("snacks")
            if snacks.picker then
                map("n", "<leader>ds", function() snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")
                map("n", "<leader>ws", function() snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")

                -- Additional snacks.nvim LSP pickers
                map("n", "<leader>gr", function() snacks.picker.lsp_references() end, "[G]o to [R]eferences (Picker)")
                map("n", "<leader>gd", function() snacks.picker.lsp_definitions() end, "[G]o to [D]efinitions (Picker)")
                map("n", "<leader>gi", function() snacks.picker.lsp_implementations() end,
                    "[G]o to [I]mplementations (Picker)")
                map("n", "<leader>gt", function() snacks.picker.lsp_type_definitions() end,
                    "[G]o to [T]ype Definitions (Picker)")
            else
                -- Fallback to built-in LSP functions
                map("n", "<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
                map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
            end
        else
            -- Fallback to built-in LSP functions
            map("n", "<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
            map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
        end

        -- Signature help (very useful while typing)
        map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- Formatting (conditional based on server capabilities)
        if client and client.supports_method("textDocument/formatting") then
            map("n", "<leader>f", function()
                vim.lsp.buf.format({
                    async = true,
                    timeout_ms = 3000,
                })
            end, "[F]ormat Document")

            -- Range formatting in visual mode
            map("v", "<leader>f", function()
                vim.lsp.buf.format({
                    async = true,
                    timeout_ms = 3000,
                })
            end, "[F]ormat Selection")

            -- Optional: Auto-format on save (uncomment if desired)
            autocmd("BufWritePre", {
                buffer = bufnr,
                group = JacobSamoGroup,
                callback = function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
                end,
            })
        end

        -- Inlay hints toggle (for supported servers)
        if client and client.supports_method("textDocument/inlayHint") then
            map("n", "<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, "[T]oggle Inlay [H]ints")

            -- Enable inlay hints by default
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Call hierarchy (if supported)
        if client and client.supports_method("textDocument/prepareCallHierarchy") then
            map("n", "<leader>ci", vim.lsp.buf.incoming_calls, "[C]all Hierarchy [I]ncoming")
            map("n", "<leader>co", vim.lsp.buf.outgoing_calls, "[C]all Hierarchy [O]utgoing")
        end

        -- Document highlighting (if supported)
        if client and client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

            autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            autocmd("LspDetach", {
                group = highlight_augroup,
                callback = function(event)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
                end,
            })
        end

        -- Codelens (if supported)
        if client and client.supports_method("textDocument/codeLens") then
            map("n", "<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens")

            -- Refresh codelens on certain events
            autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = bufnr,
                group = JacobSamoGroup,
                callback = vim.lsp.codelens.refresh,
            })
        end

        -- Print client info (useful for debugging)
        if client then
            print(string.format("LSP client '%s' attached to buffer %d", client.name, bufnr))
        end
    end
})
