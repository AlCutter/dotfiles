return {
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- Note: 'numToStr/Comment.nvim' removed as Neovim 0.10+ includes native
	-- commenting via `gc` and `gcc` with treesitter support out of the box.
}
