return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			--transparent_background = true,
			-- no_italic = true, -- Force no italic
			color_overrides = {
			--	mocha = {
			--		base = "#000000",
			--		mantle = "#000000",
			--		crust = "#000000",
			--	},
			},
			integrations = {
				telescope = {
					enabled = true,
					style = "nvchad",
				},
			},
		},
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("catppuccin-mocha")
			-- vim.cmd.hi("Comment gui=none")
		end,
	},
}
