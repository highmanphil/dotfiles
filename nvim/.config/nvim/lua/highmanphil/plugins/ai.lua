return {
	-- "ggml-org/llama.vim",
	-- "github/copilot.vim",
	"supermaven-inc/supermaven-nvim",
	event = "InsertEnter",
	config = function()
		require("supermaven-nvim").setup({})
	end,
}
