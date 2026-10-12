local map = vim.keymap.set

-- Vim-style split navigation and resizing.
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
map("n", "<A-S-h>", "<cmd>vertical resize -2<cr>", { desc = "Shrink window horizontally" })
map("n", "<A-S-l>", "<cmd>vertical resize +2<cr>", { desc = "Grow window horizontally" })
map("n", "<A-S-j>", "<cmd>resize -2<cr>", { desc = "Shrink window vertically" })
map("n", "<A-S-k>", "<cmd>resize +2<cr>", { desc = "Grow window vertically" })

map("n", "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("i", "<C-s>", "<esc><cmd>write<cr>a", { desc = "Save file" })
map("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close buffer" })
