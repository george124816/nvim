return {
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "vertical",
				size = function()
					return math.floor(vim.o.columns * 0.5)
				end,
			})
		end
	}
}
