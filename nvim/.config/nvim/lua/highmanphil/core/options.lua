vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- colors
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard = "unnamedplus" -- use system clipboard

if vim.fn.has("wsl") == 1 then
	vim.api.nvim_create_autocmd("TextYankPost", {

		group = vim.api.nvim_create_augroup("Yank", { clear = true }),

		callback = function()
			vim.fn.system("clip.exe", vim.fn.getreg('"'))
		end,
	})
end

-- split
opt.splitright = true
opt.splitbelow = true

opt.so = 4
