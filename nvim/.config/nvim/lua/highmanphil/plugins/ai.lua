-- Local AI completion, served by llama-swap on the Home PC (other machines
-- reach it over the tailnet):
--   llama.vim  FIM ghost text at the cursor  (qwen2.5-coder-7b-fim)
--   nes.nvim   next edit suggestions         (sweep-next-edit-v2-7b)
-- Both accept with <Tab>: llama.vim while its hint is shown, nes.nvim otherwise.
local host = vim.uv.os_gethostname() == "phil-cachyos" and "127.0.0.1" or "phil-cachyos.tail3a5980.ts.net"
local base = "http://" .. host .. ":10101"
local nes_dev = vim.fn.expand("~/.t3/projects/nes-nvim")

return {
	{
		"ggml-org/llama.vim",
		event = "VeryLazy",
		init = function()
			vim.g.llama_config = {
				endpoint_fim = base .. "/infill",
				model_fim = "qwen2.5-coder-7b-fim",
				show_info = 0,
				-- the defaults use <leader> in insert mode, which delays every space
				keymap_fim_trigger = "<M-f>",
				keymap_fim_accept_word = "<M-w>",
				-- no instruction model; keep normal-mode <Tab>/<Esc> free
				keymap_inst_trigger = "",
				keymap_inst_rerun = "",
				keymap_inst_continue = "",
				keymap_inst_accept = "",
				keymap_inst_cancel = "",
			}
		end,
	},
	{
		"highmanphil/nes-nvim",
		dir = vim.uv.fs_stat(nes_dev) and nes_dev or nil,
		event = "VeryLazy",
		config = function()
			require("nes").setup({
				endpoint = base .. "/v1/completions",
				model = "sweep-next-edit-v2-7b",
			})
		end,
	},
}
