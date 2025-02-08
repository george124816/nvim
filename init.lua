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
vim.opt.termguicolors = true

require("lazy").setup({
	-- theme
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "miikanissi/modus-themes.nvim", priority = 1000 },
	{ "kaicataldo/material.vim", priority = 1000 },
	{ "rebelot/kanagawa.nvim", priority = 1000 },

	-- core
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "elixir-editors/vim-elixir" },
	{ "vim-test/vim-test" },
	{ "tpope/vim-commentary" },
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-projectionist" },
	"andyl/vim-projectionist-elixir",
	{ "kassio/neoterm" },

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},
	-- rest client
	{ "rest-nvim/rest.nvim" },
	-- lsp
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local servers = {

				elixirls = {},
				gopls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				marksman = {},
			}

			require("mason").setup()

			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk)
					map("n", "<leader>hr", gitsigns.reset_hunk)
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>hS", gitsigns.stage_buffer)
					map("n", "<leader>hu", gitsigns.undo_stage_hunk)
					map("n", "<leader>hR", gitsigns.reset_buffer)
					map("n", "<leader>hp", gitsigns.preview_hunk)
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
					map("n", "<leader>hd", gitsigns.diffthis)
					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end)
					map("n", "<leader>td", gitsigns.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"emmet_language_server",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			require("lspconfig").html.setup({
				capabilities = capabilities,
			})
		end,
	},

	-- dap
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- "leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			-- require("dap-go").setup()

			-- Handled by nvim-dap-go
			-- dap.adapters.go = {
			--   type = "server",
			--   port = "${port}",
			--   executable = {
			--     command = "dlv",
			--     args = { "dap", "-l", "127.0.0.1:${port}" },
			--   },
			-- }

			-- local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
			local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
			print(elixir_ls_debugger)
			if elixir_ls_debugger ~= "" then
				dap.adapters.mix_task = {
					type = "executable",
					command = elixir_ls_debugger,
				}

				dap.configurations.elixir = {
					{
						type = "mix_task",
						name = "phoenix server",
						task = "phx.server",
						request = "launch",
						projectDir = "${workspaceFolder}",
						exitAfterTaskReturns = false,
						debugAutoInterpretAllModules = false,
					},
				}
			end

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F13>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},

	--autoformat

	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},

	-- autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = { "lua", "elixir", "sql", "go", "http", "html" },
				ignore_install = {},
				modules = {},
				auto_install = true,
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- markdown
	{ "opdavies/toggle-checkbox.nvim" },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	--- git
	{ "tpope/vim-fugitive" },
	{ "APZelos/blamer.nvim" },
	{ "lewis6991/gitsigns.nvim" },

	--- frontend
	{ "norcalli/nvim-colorizer.lua" },
	{
		"barrett-ruth/live-server.nvim",
		build = "pnpm add -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = true,
	},
})

require("colorizer").setup({
	"css",
})

-- dap
local dap = require("dap")

dap.adapters.mix_task = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/bin/elixir-ls-debugger",
	args = {},
}

dap.configurations.elixir = {
	{
		type = "mix_task",
		name = "mix test",
		task = "test",
		taskArgs = { "--trace" },
		request = "launch",
		startApps = true, -- for Phoenix projects
		projectDir = "${workspaceFolder}",
		requireFiles = {
			"test/**/test_helper.exs",
			"test/**/*_test.exs",
		},
	},
}

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.splitbelow = true

vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.relativenumber = true
vim.opt.undofile = true

vim.opt.scrolloff = 10

-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- neoterm
vim.g.neoterm_default_mod = "vert botright"
vim.g.neoterm_autoscroll = 1
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
vim.g["test#strategy"] = "neoterm"

vim.api.nvim_set_keymap("v", "<C-y>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-p>", '"+p', { noremap = true, silent = true })

vim.g.rest_nvim = {
	---@type table<string, fun():string> Table of custom dynamic variables
	--custom_dynamic_variables = {},
	-----@class rest.Config.Request
	--request = {
	--	---@type boolean Skip SSL verification, useful for unknown certificates
	--	skip_ssl_verification = false,
	--	---Default request hooks
	--	---@class rest.Config.Request.Hooks
	--	hooks = {
	--		---@type boolean Encode URL before making request
	--		encode_url = true,
	--		---@type string Set `User-Agent` header when it is empty
	--		user_agent = "rest.nvim v" .. require("rest-nvim.api").VERSION,
	--		---@type boolean Set `Content-Type` header when it is empty and body is provided
	--		set_content_type = true,
	--	},
	--},
	-----@class rest.Config.Response
	--response = {
	--	---Default response hooks
	--	---@class rest.Config.Response.Hooks
	--	hooks = {
	--		---@type boolean Decode the request URL segments on response UI to improve readability
	--		decode_url = true,
	--		---@type boolean Format the response body using `gq` command
	--		format = true,
	--	},
	--},
	-----@class rest.Config.Clients
	--clients = {
	--	---@class rest.Config.Clients.Curl
	--	curl = {
	--		---Statistics to be shown, takes cURL's `--write-out` flag variables
	--		---See `man curl` for `--write-out` flag
	--		---@type RestStatisticsStyle[]
	--		statistics = {
	--			{ id = "time_total", winbar = "take", title = "Time taken" },
	--			{ id = "size_download", winbar = "size", title = "Download size" },
	--		},
	--		---Curl-secific request/response hooks
	--		---@class rest.Config.Clients.Curl.Opts
	--		opts = {
	--			---@type boolean Add `--compressed` argument when `Accept-Encoding` header includes
	--			---`gzip`
	--			set_compressed = false,
	--		},
	--	},
	--},
	-----@class rest.Config.Cookies
	--cookies = {
	--	---@type boolean Whether enable cookies support or not
	--	enable = true,
	--	---@type string Cookies file path
	--	path = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rest-nvim.cookies"),
	--},
	-----@class rest.Config.Env
	--env = {
	--	---@type boolean
	--	enable = true,
	--	---@type string
	--	pattern = ".*%.env.*",
	--},
	-----@class rest.Config.UI
	--ui = {
	--	---@type boolean Whether to set winbar to result panes
	--	winbar = true,
	--	---@class rest.Config.UI.Keybinds
	--	keybinds = {
	--		---@type string Mapping for cycle to previous result pane
	--		prev = "H",
	--		---@type string Mapping for cycle to next result pane
	--		next = "L",
	--	},
	--},
	-----@class rest.Config.Highlight
	--highlight = {
	--	---@type boolean Whether current request highlighting is enabled or not
	--	enable = true,
	--	---@type number Duration time of the request highlighting in milliseconds
	--	timeout = 750,
	--},
	-----@see vim.log.levels
	-----@type integer log level
	--_log_level = vim.log.levels.WARN,
}

-- configuration file
vim.keymap.set("n", "<leader>cf", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>so", ":source %<CR>")

-- file map
vim.keymap.set("n", "<leader>ft", ":Neotree<CR>")
vim.keymap.set("n", "<leader>fs", ":w<CR>")
vim.keymap.set("n", "<leader>fr", "e %<CR>")
vim.keymap.set("n", "<leader>qq", ":q<CR>")
vim.keymap.set("n", "<leader>Q", ":q!<CR>")
vim.keymap.set("n", "<leader>wd", ":q<CR>")
vim.keymap.set("n", "<leader>fe", ":Ex<CR>")

-- buffer map
vim.keymap.set("n", "<leader>bn", ":enew<CR>")
vim.keymap.set("n", "<leader><Tab>", ":e #<CR>")

-- window map
vim.keymap.set("n", "<leader>w/", ":vsp<CR>")
vim.keymap.set("n", "<leader>w-", ":sp<CR>")
vim.keymap.set("n", "<leader>wh", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>wj", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>wk", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>wl", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>tt", ":Ttoggle<CR>")

-- git
vim.keymap.set("n", "<leader>gs", ":G<CR>")

-- telescope map
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- quickfix list navigation
vim.keymap.set("n", "<leader>cn", vim.cmd.cnext)
vim.keymap.set("n", "<leader>cp", vim.cmd.cprev)
vim.keymap.set("n", "<leader>co", vim.cmd.copen, { silent = true })
vim.keymap.set("n", "<leader>cc", vim.cmd.cc, { silent = true })
vim.keymap.set("n", "<leader>cC", vim.cmd.cclose, { silent = true })

-- testing
vim.keymap.set("n", "<leader>ts", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>")
vim.keymap.set("n", "<leader>tr", ":TestLast<CR>")
vim.keymap.set("n", "gt", ":A<CR>")

-- elixir keymaps

vim.keymap.set(
	"n",
	"<leader>tp",
	":T MIX_ENV=dev mix compile --warnings-as-errors && mix format && mix credo && mix dialyzer && mix test<CR>",
	{ noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>tm", ":T MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate<CR>")

vim.keymap.set("n", "<leader>tq", ":Tkill<CR>")

-- toggle check-box
vim.keymap.set("n", "<leader>x", ":lua require('toggle-checkbox').toggle()<CR>")

-- vim.cmd.colorscheme("catppuccin-mocha") -- catppuccin catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- vim.cmd.colorscheme("modus_vivendi") -- modus_operandi, modus_vivendi
vim.cmd.colorscheme("industry")
