vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<C-e>", vim.cmd.Explore, { desc = "Open explorer" })
vim.keymap.set("n", "<leader>n", ":enew<CR>", { desc = "New empty buffer" })

-- Normal mode mapping from macos -> linux
vim.keymap.set('n', 'D', 'M', { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
