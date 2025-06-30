return {
	{ "m4xshen/hardtime.nvim", 
   	dependencies = { "MunifTanjim/nui.nvim" },
   	lazy = false,
   	opts = {},
	},
	{ "iamcco/markdown-preview.nvim",
  	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  	build = "cd app && yarn install",
        init = function()
          vim.g.mkdp_filetypes = { "markdown" }
  	end,
        ft = { "markdown" },
	},
}
