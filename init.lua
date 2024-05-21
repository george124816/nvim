local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- theme
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- core
        {'nvim-telescope/telescope.nvim', 
	  dependencies = {'nvim-lua/plenary.nvim'}
  	},
	{'nvim-treesitter/nvim-treesitter',
	  build = ':TSUpdate',
	  config = function()
		  local configs = require("nvim-treesitter.configs")

		  configs.setup({
			  ensure_installed = { "lua", "elixir" },
			  auto_install = true,
			  sync_install = false,
			  highlight = { enable = true },
			  indent = { enable = true},
		  })
	  end},
	{'vim-test/vim-test'},
	{'tpope/vim-commentary'},
	{'kassio/neoterm'},

	-- markdown
	{'preservim/vim-markdown'},
	{'opdavies/toggle-checkbox.nvim'},

	--- git
	{'tpope/vim-fugitive'}
})

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.splitbelow = true

vim.opt.number = true
vim.opt.relativenumber = true

-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- neoterm
vim.g.neoterm_default_mod = 'vert botright'
vim.g.neoterm_autoscroll = 1
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
vim.g["test#strategy"] = "neoterm"

vim.api.nvim_set_keymap('v', '<C-y>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-p>', '"+p', { noremap = true, silent = true })

-- configuration file
vim.keymap.set('n', '<leader>cf', ':e ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>so', ':source %<CR>')

-- file map
vim.keymap.set('n', '<leader>fs', ':w<CR>')
vim.keymap.set('n', '<leader>qq', ':q<CR>')
vim.keymap.set('n', '<leader>Q', ':q!<CR>')
vim.keymap.set('n', '<leader>wd', ':q<CR>')
vim.keymap.set('n', '<leader>fe', ':e .<CR>')

-- buffer map
vim.keymap.set('n', '<leader>bn', ':enew<CR>')
vim.keymap.set('n', '<leader><Tab>', ':e #<CR>')

-- window map
vim.keymap.set('n', '<leader>w/', ':vsp<CR>')
vim.keymap.set('n', '<leader>wh', ':wincmd h<CR>')
vim.keymap.set('n', '<leader>wj', ':wincmd j<CR>')
vim.keymap.set('n', '<leader>wk', ':wincmd k<CR>')
vim.keymap.set('n', '<leader>wl', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>tt', ':Ttoggle<CR>')

-- git
vim.keymap.set('n', '<leader>gs', ':G<CR>')

-- telescope map
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Testing

vim.keymap.set('n', '<leader>ts', ':TestNearest<CR>')
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<leader>ta', ':TestSuite<CR>')
vim.keymap.set('n', '<leader>tr', ':TestLast<CR>')

vim.keymap.set('n', '<leader>tq', ':Tkill<CR>')

-- toggle check-box
vim.keymap.set("n", "<leader>x", ":lua require('toggle-checkbox').toggle()<CR>")

-- set theme 
vim.cmd.colorscheme "catppuccin-frappe"  -- catppuccin catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

