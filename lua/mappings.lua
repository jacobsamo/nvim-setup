require "nvchad.mappings"

-- add yours here


vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
vim.keymap.set("i", "jk", "<ESC>")

-- vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- same as option + up arrow
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- same as option + down arrow



vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- format file

-- copy paste items
vim.keymap.set("x", "<leader>p", [["_dP]]) -- makes it paste while keeping the item on clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]]) -- copies the item to clipboard rather than the vim clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) -- deletes items


vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
