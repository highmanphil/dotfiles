return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "mfussenegger/nvim-dap", lazy = true },
		{ "mfussenegger/nvim-dap-python", lazy = true }, --optional
		{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	},
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>" },
	},
	---@type venv-selector.Config
	opts = {
		-- Your settings go here
	},
}
