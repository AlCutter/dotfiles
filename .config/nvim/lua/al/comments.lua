return {
	-- Highlight todo, notes, etc in comments
	{
		--"ynhhoJ/todo-comments.nvim",
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
}
