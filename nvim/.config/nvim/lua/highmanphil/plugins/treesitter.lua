local ensure_installed = {
	"json",
	"javascript",
	"typescript",
	"tsx",
	"yaml",
	"html",
	"css",
	"prisma",
	"markdown",
	"markdown_inline",
	"svelte",
	"graphql",
	"bash",
	"lua",
	"vim",
	"dockerfile",
	"gitignore",
	"query",
	"vimdoc",
	"c",
	"python",
	"go",
	"gomod",
	"gotmpl",
	"gowork",
	"templ",
	"java",
}

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = function()
		local treesitter = require("nvim-treesitter")

		treesitter.install(ensure_installed, { max_jobs = 1 }):wait(300000)
		treesitter.update(nil, { max_jobs = 1 }):wait(300000)
	end,
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup()

		local installed = treesitter.get_installed("parsers")
		local missing = vim.tbl_filter(function(parser)
			return not vim.tbl_contains(installed, parser)
		end, ensure_installed)

		if #missing > 0 then
			treesitter.install(missing, { max_jobs = 1 })
		end

		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("highmanphil-treesitter", { clear = true }),
			callback = function()
				if pcall(vim.treesitter.start) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
