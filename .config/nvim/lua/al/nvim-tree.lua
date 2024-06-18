return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})

			local function open_nvim_tree(data)
				-- buffer is a real file on the disk
				local real_file = vim.fn.filereadable(data.file) == 1

				-- buffer is a [No Name]
				local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

				if not real_file and not no_name then
					return
				end

				-- open the tree, find the file but don't focus it
				require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
			end

			vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

			-- Make :bd and :q behave as usual when tree is visible
			vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
				nested = false,
				callback = function(e)
					local tree = require("nvim-tree.api").tree

					-- Nothing to do if tree is not opened
					if not tree.is_visible() then
						return
					end

					-- How many focusable windows do we have? (excluding e.g. incline status window)
					local winCount = 0
					for _, winId in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(winId).focusable then
							winCount = winCount + 1
						end
					end

					-- We want to quit and only one window besides tree is left
					if e.event == "QuitPre" and winCount == 2 then
						vim.api.nvim_cmd({ cmd = "qall" }, {})
					end

					-- :bd was probably issued an only tree window is left
					-- Behave as if tree was closed (see `:h :bd`)
					if e.event == "BufEnter" and winCount == 1 then
						-- Required to avoid "Vim:E444: Cannot close last window"
						vim.defer_fn(function()
							-- close nvim-tree: will go to the last buffer used before closing
							tree.toggle({ find_file = true, focus = true })
							-- re-open nivm-tree
							tree.toggle({ find_file = true, focus = false })
						end, 10)
					end
				end,
			})
		end,
	},
}
