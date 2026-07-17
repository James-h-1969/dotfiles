vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Center cursor after upward or downward scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc="Center cursor after downward scroll"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc="Center cursor after upward scroll"})

-- Keep block highlighted after move 
vim.keymap.set("v", "<", "<gv", {desc="Keep block highlighted afer shift left"})
vim.keymap.set("v", ">", ">gv", {desc="Keep block highlighted afer shift right"})

