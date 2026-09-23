return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({})

			-- In Neovim 0.12+, treesitter highlighting and indentation are started natively
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user-treesitter-start", { clear = true }),
				callback = function(args)
					-- Start native treesitter highlighting if a parser exists for this buffer
					pcall(vim.treesitter.start, args.buf)
					-- Use treesitter for indentation
					pcall(function()
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
				end,
			})
		end,
	},
}
