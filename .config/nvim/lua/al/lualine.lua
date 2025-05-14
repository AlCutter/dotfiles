return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		-- PERF: we don't need this lualine require madness
		-- local lualine_require = require("lualine_require")
		-- lualine_require.require = require
		--
		local empty = require('lualine.component'):extend()
		function empty:draw(default_highlight)
			self.status = ''
			self.applied_separator = ''
			self:apply_highlights(default_highlight)
			self:apply_section_separators()
			return self.status
		end


		-- Put proper separators and gaps between components in sections
		local function process_sections(sections)
			for name, section in pairs(sections) do
				local left = name:sub(9, 10) < 'x'
				for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
					table.insert(section, pos * 2, { empty })
				end
				for id, comp in ipairs(section) do
					if type(comp) ~= 'table' then
						comp = { comp }
						section[id] = comp
					end
					comp.separator = left and { right = '' } or { left = '' }
				end
			end
			return sections
		end


		vim.o.laststatus = vim.g.lualine_laststatus
		local opts = {
			options = {
				theme = "catppuccin",
				component_separators = "",
				globalstatus = vim.o.laststatus == 3,
				section_separators = "",
				disabled_filetypes = {
					statusline = { "snacks_dashboard" },
				},
				ignore_focus = {
					"dap-repl",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_scopes",
					"dapui_stacks",
					"dapui_watches",
				},
			},
			extensions = { "lazy", "mason", "nvim-dap-ui", "oil", "trouble", "quickfix" },
			sections = process_sections {
				lualine_a = {
					{
						require("lazy.status").updates,
						fmt = function()
							return require("lazy.status").updates() or "  "
						end,
						padding = 0,
					},
				},
				lualine_b = {
					{ "filetype", icon_only = true, padding = { left = 2 } },
					{
						"filename",
						symbols = {
							modified = "󰯹 ",
							readonly = "󰰠 ",
							unnamed = "󰰩 ",
							newfile = "󰰔 ",
						},
						padding = { left = 1 },
					},
				},
				lualine_c = {
					{ "branch", icon = " ", padding = { left = 2 } },
					{
						"diff",
						diff_color = {
							added = "GitSignsAdd",
							modified = "GitSignsChange",
							removed = "GitSignsDelete",
						},
						symbols = { added = "󰯭 ", modified = "󰯳 ", removed = "󰯶 " },
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
						padding = { left = 1 },
					},
				},
				lualine_x = { { "lsp_status", icon = "", symbols = { done = "●" } } },
				lualine_y = {
					{
						"macro",
						fmt = function()
							local reg = vim.fn.reg_recording()
							if reg == "" then
								return ""
							end
							return "󰑋 " .. reg
						end,
						padding = { right = 2 },
					},
				},
				lualine_z = {
					{ "location", padding = { right = 1 } },
					{ "progress", padding = 0 },
				},
			},
			inactive_sections = {
				lualine_a = {
					{ "filetype", icon_only = true, padding = 0 },
					{ "filename", padding = 0 },
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		}
		return opts
	end,
}

