return {
	{
		"vim-test/vim-test",
		config = function()
			vim.g['test#strategy'] = 'toggleterm'
		end,
	},
	{
		"tpope/vim-projectionist",
		config = function()
			vim.g.projectionist_heuristics = {
				["go.mod"] = {
					["*.go"] = {
						["alternate"] = "{}_test.go",
						["type"] = "source"
					},
					["*_test.go"] = {
						["alternate"] = "{}.go",
						["type"] = "test"
					}
				}
			}
		end,
	},
	"andyl/vim-projectionist-elixir",
	"elixir-editors/vim-elixir"
}
