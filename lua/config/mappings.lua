vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
vim.keymap.set("i", "jk", "<ESC>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- same as option + up arrow
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- same as option + down arrow
