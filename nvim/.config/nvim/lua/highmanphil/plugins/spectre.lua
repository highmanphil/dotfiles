return {
	"nvim-pack/nvim-spectre",
	cmd = "Spectre",
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").toggle()
			end,
			desc = "Replace in files (Spectre)",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search current word",
		},
		{
			"<leader>sp",
			function()
				require("spectre").open_file_search()
			end,
			desc = "Search in current file",
		},
	},
	config = function()
		require("spectre").setup()
		-- 🍦 Use catppuccin palette
		local cp = require("catppuccin.palettes").get_palette()

		vim.api.nvim_set_hl(0, "SpectreSearch", { fg = cp.red, bg = cp.surface0, bold = true })
		vim.api.nvim_set_hl(0, "SpectreReplace", { fg = cp.green, bg = cp.surface0, bold = true })
		vim.api.nvim_set_hl(0, "SpectreFile", { fg = cp.blue, bold = true })
		vim.api.nvim_set_hl(0, "SpectreBorder", { fg = cp.overlay1 })
		vim.api.nvim_set_hl(0, "SpectreHeader", { fg = cp.mauve, bold = true })
		vim.api.nvim_set_hl(0, "SpectreSelectLine", { bg = cp.surface1 })
	end,
}
