-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- In keymaps.lua or wherever keymaps are defined
vim.api.nvim_set_keymap(
  "n", -- Mode: normal
  "<leader>e", -- Keymap: <leader>e (you can change this)
  ":Neotree focus<CR>", -- Command: Focus Neo-tree
  { noremap = true, silent = true } -- Options
)

vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
