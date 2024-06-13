return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		-- config = function()
		-- end,
		init = function()
			vim.g.barbar_auto_setup = false
			vim.keymap.set("n", "<leader>bc", "<cmd>BufferClose<CR>", { desc = "Close the current buffer" })
			vim.keymap.set("n", "<leader>bn", "<cmd>BufferNext<CR>", { desc = "Go to the Next buffer" })
			vim.keymap.set("n", "<leader>bp", "<cmd>BufferPrevious<CR>", { desc = "Go to the Previous buffer" })
			vim.keymap.set("n", "<leader>bm", "<cmd>BufferPick<CR>", { desc = "Open the Magic buffer picker" })
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
}
