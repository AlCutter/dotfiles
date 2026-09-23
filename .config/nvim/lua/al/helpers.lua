return {
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			spec = {
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>h", group = "[H]arpoon" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>x", group = "Trouble / Diagnostic" },
			},
		},
	},
}
