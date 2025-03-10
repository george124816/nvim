return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "auto", -- latte, frappe, macchiato, mocha
                background = { light = "latte", dark = "mocha" },
                transparent_background = false,
                show_end_of_buffer = false,
                term_colors = false,
                dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
                no_italic = false,
                no_bold = false,
                no_underline = false,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = {},
                default_integrations = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
		    telescope = true,
                    notify = false,
                    mini = { enabled = true, indentscope_color = "" },
                },
            })
            -- Definir o esquema de cores após a configuração
            -- vim.cmd.colorscheme "catppuccin"
	    vim.cmd.colorscheme "catppuccin-mocha" -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        end,
    },
}

