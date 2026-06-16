return {
	{
		"williamboman/mason.nvim",
		version = "2.0.0",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- import mason
			local mason = require("mason")

			-- import mason-lspconfig
			local mason_lspconfig = require("mason-lspconfig")

			-- import mason-tool-installer
			local mason_tool_installer = require("mason-tool-installer")

			-- enable mason and configure icons
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				automatic_installation = {},
				ensure_installed = {
					"html",
					"cssls",
					"tailwindcss",
					"svelte",
					"lua_ls",
					"graphql",
					"emmet_ls",
					"ts_ls",
					"prismals",
					"pyright",
					"gopls",
					"templ",
					"yamlls",
					"ruff", -- python formatter/linter/lsp
					"jdtls",
					"eslint",
				},
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"pylint",
					"golangci-lint",
					"templ",
					"goimports",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "2.0.0",
		dependencies = {
			"williamboman/mason.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
	},
}
