-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = map

map("n", ";", ":", { desc = "CMD enter command mode" })

-- Focus or open explorer with '\'
map("n", "\\", function()
  -- Try to find the explorer window
  local explorer_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == "snacks_picker_list" then
      explorer_win = win
      break
    end
  end
  if explorer_win and vim.api.nvim_get_current_win() ~= explorer_win then
    vim.api.nvim_set_current_win(explorer_win)
  else
    require("snacks").explorer()
  end
end, { desc = "Focus or open Snacks Explorer" })

-- Close explorer with '\\'
map("n", "\\\\", function()
  local explorer_pickers = require("snacks.picker").get({ source = "explorer" })
  if explorer_pickers[2] then
    explorer_pickers[2]:close()
  end
end, { desc = "Close Snacks Explorer" })
