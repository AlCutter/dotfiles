return {
	{
		"chrisgrieser/nvim-spider",
		config = function()
			vim.keymap.set(
				{ "n", "o", "x" },
				"w",
				"<cmd>lua require('spider').motion('w', { skipInsignificantPunctuation = false })<CR>",
				{ desc = "Spider-w" }
			)
			vim.keymap.set(
				{ "n", "o", "x" },
				"e",
				"<cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = false })<CR>",
				{ desc = "Spider-e" }
			)
			vim.keymap.set(
				{ "n", "o", "x" },
				"b",
				"<cmd>lua require('spider').motion('b', { skipInsignificantPunctuation = false })<CR>",
				{ desc = "Spider-b" }
			)
		end,
	},
}
