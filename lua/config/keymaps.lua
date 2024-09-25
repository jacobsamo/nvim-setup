-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- copy and paste items
vim.keymap.set("x", "<leader>p", [["_dP]]) -- makes it paste while keeping the item on clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]]) -- copies the item to clipboard rather than the vim clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
