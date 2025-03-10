return {

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup()

			local servers_to_format = { "gopls", "elixirls", "lua_ls" }
			local on_attach = function(client, bufnr)
				-- Enable formatting on save for Go (gopls), Elixir (elixirls), and Lua (lua-ls)
				if vim.tbl_contains(servers_to_format, client.name) then
					-- Set up formatting on save
					vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
				end

				-- Set up the keymap for Go to definition (for all LSP servers)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',
					{ noremap = true, silent = true })
				-- Add more key mappings for other LSP functions if needed
			end

			-- local on_attach = function(client, bufnr)
			-- 	-- Set up the keymap for Go to definition
			-- 	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',
			-- 		{ noremap = true, silent = true })
			-- 	-- You can add more LSP-related key mappings here
			-- end
			--
			require("mason-lspconfig").setup_handlers {
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup {
						on_attach = on_attach, -- Attach common settings for all LSP servers
					}
				end,
				-- Next, you can provide a dedicated handler for specific servers.
				-- For example, a handler override for the `rust_analyzer`:
				-- ["gopls"] = function()
				-- 	require("lspconfig").gopls.setup({
				-- 		cmd = { "gopls" }, -- Certifique-se de que o comando está correto
				-- 		settings = {
				-- 			gopls = {
				-- 				analyses = {
				-- 					unreachable = true,
				-- 					unusedparams = true,
				-- 				},
				-- 				staticcheck = true,
				-- 			},
				-- 		},
				-- 	})
				-- end,


			}
		end,
	},


	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' }, -- For `vsnip` users.
					-- { name = 'luasnip' }, -- For `luasnip` users.
					-- { name = 'ultisnips' }, -- For `ultisnips` users.
					-- { name = 'snippy' }, -- For `snippy` users.
				}, {
					{ name = 'buffer' },
				}),
			})

			-- Setup cmdline completion
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = 'buffer' } },
			})

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' },
				}, {
					{ name = 'cmdline' },
				}),
			})
		end,
	},
	{ "hrsh7th/cmp-vsnip" },
	{ "hrsh7th/vim-vsnip" },
}
