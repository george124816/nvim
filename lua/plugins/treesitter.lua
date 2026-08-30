local ensure_installed = {
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"go",
	"elixir",
	"kotlin",
	"python",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()

		require("nvim-treesitter").install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			callback = function(args)
				local buf = args.buf

				-- Skip very large files to keep highlighting responsive.
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return
				end

				local lang = vim.treesitter.language.get_lang(args.match)
				if lang and vim.treesitter.language.add(lang) then
					vim.treesitter.start(buf, lang)
				end
			end,
		})
	end,
}
