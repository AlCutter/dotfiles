-- Set <space> as the leader key (must happen before plugins are loaded)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- Line numbers & cursorline
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Mouse & Mode
vim.opt.mouse = "a"
vim.opt.showmode = false

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Indentation & formatting
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Undo & search
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Sign column & timing
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Scroll behavior (smooth scrolling native in Neovim 0.10+)
vim.opt.scrolloff = 20
vim.opt.smoothscroll = true

-- Session options (including localoptions for auto-session health)
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Native Treesitter Folding (Neovim 0.12+)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- [[ Diagnostic Configuration ]]
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	virtual_text = {
		spacing = 4,
		prefix = "●",
	},
	severity_sort = true,
	float = {
		border = "rounded",
	},
})

-- [[ Basic Keymaps ]]
-- Clear search highlight on <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps (0.11+ built-in [d and ]d with modern jump API)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous [D]iagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next [D]iagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Paste over selection without replacing the clipboard register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection without altering register" })

-- Arrow keys reminder
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Note: Window navigation (<C-h>, <C-j>, <C-k>, <C-l>) is handled seamlessly
-- across Neovim splits and tmux panes via 'christoomey/vim-tmux-navigator' in lua/al/tmux.lua.

-- [[ Basic Autocommands ]]
-- Highlight when yanking text (vim.hl.on_yank in 0.11+)
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
	-- Automatically detect tabstop and shiftwidth
	"tpope/vim-sleuth",

	-- Git integration
	"tpope/vim-fugitive",

	-- Auto session management
	{
		"rmagatti/auto-session",
		opts = {
			log_level = "error",
		},
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- Scrollbar
	{
		"petertriho/nvim-scrollbar",
		opts = {},
	},

	-- Git gutter signs and utilities
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true,
		},
	},

	-- Collection of various small independent modules
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Around/Inside textobjects (e.g. va), yinq, ci')
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (e.g. saiw), sd', sr)')
			require("mini.surround").setup()

			-- Jump navigation
			require("mini.jump").setup()
			require("mini.jump2d").setup()
		end,
	},

	-- Render markdown inline
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown" },
		},
		ft = { "markdown" },
	},

	-- Import all custom modular plugin configurations from lua/al/
	{ import = "al" },
}, {
	rocks = {
		enabled = false, -- Disabled to avoid luarocks/hererocks warnings on systems without it
	},
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
