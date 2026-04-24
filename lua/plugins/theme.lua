return {
	{
		"romanaverin/charleston.nvim",
		name = "charleston",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme "charleston"
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	}
}
