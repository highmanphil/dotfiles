return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local opts = { buf = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", "<cmd>lsp restart<CR>", opts)

				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, ev.buf) then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.diagnostic.config({
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			virtual_text = {
				prefix = "●",
				source = "if_many",
			},
		})

		vim.filetype.add({
			extension = {
				gotmpl = "gotmpl",
				tmpl = "gotmpl",
				templ = "templ",
			},
		})

		vim.lsp.config("eslint", {
			settings = {
				eslint = {
					autoFixOnSave = true,
					experimental = {
						useFlatConfig = true,
					},
					format = {
						enable = true,
					},
				},
			},
		})
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})
		vim.lsp.config("tailwindcss", {
			settings = {
				tailwindCSS = {
					includeLanguages = {
						templ = "html",
					},
				},
			},
		})
		vim.lsp.config("pyright", {
			settings = {
				pyright = {
					-- using Ruffs import organizer
					disableOrganizeImports = true,
				},
				-- python = {
				-- 	analysis = {
				-- 		ignore = { "*" },
				-- 	},
				-- },
			},
		})
		vim.lsp.config("jdtls", {
			settings = {
				-- java.jdt.ls.java.home
				java = {
					jdt = {
						ls = {
							java = {
								home = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home/",
							},
						},
					},
					configuration = {
						runtimes = {
							{
								name = "JavaSE-17",
								path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
								default = true,
							},
							{
								name = "JavaSE-21",
								path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home/",
							},
						},
					},
				},
			},
		})
	end,
}
