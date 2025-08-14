-- Create augroup for LSP keymaps
local augroup = vim.api.nvim_create_augroup
local JacobSamoGroup = augroup("JacobSamo", { clear = true })

local autocmd = vim.api.nvim_create_autocmd

-- Enhanced LSP attach autocmd with comprehensive keybinds
autocmd("LspAttach", {
	group = JacobSamoGroup,
	callback = function(e)
		local function map(mode, keys, func, desc)
			vim.keymap.set(mode, keys, func, {
				buffer = e.buf,
				desc = "LSP: " .. desc,
			})
		end

		-- Goto
		map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
		map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
		map("n", "gr", vim.lsp.buf.references, "Goto References")
		map("n", "gt", vim.lsp.buf.type_definition, "Goto Type Definition")

		-- Hover & Signature
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")

		-- Code actions & rename
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")

		-- Diagnostics
		map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
		map("n", "<leader>e", vim.diagnostic.open_float, "Show Diagnostic")
		map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics to List")

		-- Workspace
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List Workspace Folders")
		map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Search Workspace Symbols")
	end,
})
