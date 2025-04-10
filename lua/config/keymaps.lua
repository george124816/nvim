local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>cf", ":e ~/.config/nvim/lua/config/keymaps.lua<CR>")

-- Telescope
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })

vim.keymap.set("n", "<Leader>fs", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>qq", ":q<CR>", { noremap = true, silent = true })

-- Clipboard
vim.keymap.set("v", "<C-y>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", '"+p', { noremap = true, silent = true })
vim.keymap.set("v", "<C-p>", '"+p', { noremap = true, silent = true })

-- Files
vim.keymap.set("n", "<leader>fe", ":Ex<CR>")

-- Windows
vim.keymap.set("n", "<leader>wl", ":wincmd l<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wk", ":wincmd k<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wj", ":wincmd j<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wh", ":wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wd", ":close<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>w-", ":split<CR>:wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>w/", ":vsplit<CR>:wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader><Tab>', ':b#<CR>', { noremap = true, silent = true })

-- Buffers
vim.keymap.set("n", "<leader>bn", ":enew<CR>")

-- LSP
vim.api.nvim_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

-- Git
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true })

-- Test
vim.api.nvim_set_keymap('n', '<leader>ts', ':TestNearest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tf', ':TestFile<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ta', ':TestSuite<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tr', ':TestLast<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gt", ":A<CR>", { noremap = true, silent = true })

-- Terminal
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>")
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Elixir
vim.keymap.set("n", "<leader>tm", ':TermExec cmd="MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate"<CR>')

-- CodeCompanion
vim.keymap.set("n", "<leader>cc", ":CodeCompanionChat<CR>", { desc = "Abrir chat do CodeCompanion" })
