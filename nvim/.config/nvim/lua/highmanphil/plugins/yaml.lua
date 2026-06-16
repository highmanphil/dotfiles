return {
	{
		"cuducos/yaml.nvim",
		ft = { "yaml", "yml" }, -- optional
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"folke/snacks.nvim", -- optional
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		keys = {
			{ "<leader>yt", ":YAMLTelescope<CR>", desc = "Find yaml key/value using telescope" },
			{ "<leader>yl", "!yamllint %<CR>", desc = "Lint yaml file" },
		},
	},
	{
		"cwrau/yaml-schema-detect.nvim",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		ft = { "yaml" },
	},
	-- {
	-- 	{
	-- 		"someone-stole-my-name/yaml-companion.nvim",
	-- 		dependencies = {
	-- 			{ "neovim/nvim-lspconfig" },
	-- 			{ "nvim-lua/plenary.nvim" },
	-- 			{ "nvim-telescope/telescope.nvim" },
	-- 		},
	-- 		config = function()
	-- 			require("telescope").load_extension("yaml_schema")
	-- 		end,
	-- 		keys = {
	-- 			{ "<leader>ys", ":Telescope yaml_schema<CR>", desc = "Change yaml_schema" },
	-- 		},
	-- 	},
	-- },
}
