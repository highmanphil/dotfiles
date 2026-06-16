return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			themes = {
				"catppuccin-latte",
				"catppuccin-frappe",
				"catppuccin-macchiato",
				"catppuccin-mocha",
				"codedark",
			},
			livePreview = true,
			-- globalAfter = [[
			--      require("lualine").refresh()
			--    ]],
		})
	end,
}
