return {
	{
		"nvim-treesitter/nvim-treesitter-refactor",
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"comment",
				"go",
				"html",
				"gitignore",
				"jq",
				"lua",
				"luadoc",
				"make",
				"markdown",
				"ssh_config",
				"terraform",
				"vim",
				"vimdoc",
				"yaml",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<c-backspace>",
				},
			},
			refactor = {
				highlight_current_scope = { enable = true },
				smart_rename = {
					enable = true,
					-- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
					keymaps = {
						smart_rename = "grr",
					},
				},
			},
			navigation = {
				enable = true,
				-- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
				keymaps = {
					goto_definition = "gnd",
					list_definitions = "gnD",
					list_definitions_toc = "gO",
					goto_next_usage = "<a-*>",
					goto_previous_usage = "<a-#>",
				},
			},
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)
			-- {
			-- 	textobjects = {
			-- 		select = {
			-- 			enable = true,
			-- 			keymaps = {
			-- 				-- Your custom capture.
			-- 				["aF"] = "@custom_capture",

			-- 				-- Built-in captures.
			-- 				["af"] = "@function.outer",
			-- 				["if"] = "@function.inner",
			-- 			},
			-- 		},
			-- 	},
			-- })

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
}
