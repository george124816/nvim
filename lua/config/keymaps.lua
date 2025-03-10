local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })

vim.keymap.set("n", "<Leader>fs", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>qq", ":q<CR>", { noremap = true, silent = true })

vim.keymap.set("v", "<C-y>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", '"+p', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true })
