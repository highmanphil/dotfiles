return {
	"gelguy/wilder.nvim",
	event = "CmdlineEnter",
	build = ":UpdateRemotePlugins",
	config = function()
		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })

		-- Use fuzzy matching
		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.cmdline_pipeline({
					fuzzy = 1,
					fuzzy_filter = wilder.lua_fzy_filter(),
				}),
				wilder.search_pipeline()
			),
		})

		-- Renderer with popup menu
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				border = "rounded",
				highlights = {
					border = "Normal",
				},
				highlighter = wilder.lua_fzy_highlighter(),
			}))
		)
	end,
	dependencies = {
		"romgrk/fzy-lua-native", -- optional, speeds up fuzzy matching
	},
}
