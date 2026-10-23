-- Local AI completion:
--   llama.vim  FIM ghost text at the cursor
--   nes.nvim   next edit suggestions (Sweep next-edit model)
-- Both accept with <Tab>: llama.vim while its hint is shown, nes.nvim otherwise.
--
-- macOS: models run locally, set up by nes-nvim/scripts/setup-macos.sh
--   (:8013 next edits, :8012 FIM).
-- Home PC: llama-swap on :10101, where the editor models swap with chat models.
local mac = vim.fn.has("mac") == 1
local nes_endpoint, nes_model, fim_endpoint, fim_model
if mac then
	nes_endpoint = "http://127.0.0.1:8013/v1/completions"
	nes_model = vim.env.NES_MODEL or "sweep-next-edit-v2-7b-q4"
	fim_endpoint = "http://127.0.0.1:8012/infill"
	fim_model = ""
else
	nes_endpoint = "http://127.0.0.1:10101/v1/completions"
	nes_model = "sweep-next-edit-v2-7b"
	fim_endpoint = "http://127.0.0.1:10101/infill"
	fim_model = "qwen2.5-coder-7b-fim"
end
local nes_dev = vim.fn.expand("~/.t3/projects/nes-nvim")

return {
	{
		"ggml-org/llama.vim",
		event = "VeryLazy",
		init = function()
			vim.g.llama_config = {
				endpoint_fim = fim_endpoint,
				model_fim = fim_model,
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
				endpoint = nes_endpoint,
				model = nes_model,
			})
		end,
	},
}
