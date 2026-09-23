return {
	{ -- LuaLS setup for Neovim config, runtime and plugins
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			--  Autocommand run when an LSP attaches to a buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Telescope LSP navigation
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					-- Built-in LSP actions (Neovim 0.11+ also provides global defaults:
					-- grn = rename, gra = code action, gri = implementation, grr = references, K = hover)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Toggle Inlay Hints (Neovim 0.10+ native)
					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							local current = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
							vim.lsp.inlay_hint.enable(not current, { bufnr = event.buf })
						end, "[T]oggle Inlay [H]ints")
					end

					-- Highlight references under cursor
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- Broadcast nvim-cmp capabilities to language servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Native Neovim 0.11/0.12 LSP configuration
			-- Set capabilities for all servers
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Language server specific configs
			local servers = {
				gopls = {},
				terraformls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			-- Setup Mason (manual installation via :Mason if needed)
			require("mason").setup()
			require("mason-lspconfig").setup()

			-- Configure and enable servers using native vim.lsp
			for server_name, server_opts in pairs(servers) do
				if server_opts and next(server_opts) ~= nil then
					vim.lsp.config[server_name] = server_opts
				end
				local cfg = vim.lsp.config[server_name]
				local cmd = cfg and cfg.cmd and cfg.cmd[1]
				if not cmd or vim.fn.executable(cmd) == 1 then
					vim.lsp.enable(server_name)
				end
			end
		end,
	},
}
