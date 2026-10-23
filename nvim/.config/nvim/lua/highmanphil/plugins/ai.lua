-- Local AI completion:
--   llama.vim  FIM ghost text at the cursor
--   nes.nvim   next edit suggestions (Sweep next-edit model)
-- Both accept with <Tab>: llama.vim while its hint is shown, nes.nvim otherwise.
--
-- Servers, in order of preference:
--   1. on this machine: nes-nvim/scripts/setup-macos.sh (:8013 next edits,
--      :8012 FIM), used when it is running
--   2. llama-swap on the Home PC (:10101), where the editor models swap with
--      the chat models; reached over the tailnet from other machines
local home_pc = vim.uv.os_gethostname() == "phil-cachyos" and "127.0.0.1" or "100.104.47.26"

-- true when something answers on the port (connection refused returns at once)
local function listening(port)
	local r = vim.system({ "curl", "-s", "-o", "/dev/null", "-m", "0.3", "http://127.0.0.1:" .. port .. "/health" }):wait()
	return r.code == 0
end

local nes_endpoint, nes_model, fim_endpoint, fim_model
if listening(8013) then
	nes_endpoint = "http://127.0.0.1:8013/v1/completions"
	nes_model = vim.env.NES_MODEL or "sweep-next-edit-v2-7b"
else
	nes_endpoint = "http://" .. home_pc .. ":10101/v1/completions"
	nes_model = "sweep-next-edit-v2-7b"
end
if listening(8012) then
	fim_endpoint, fim_model = "http://127.0.0.1:8012/infill", ""
else
	fim_endpoint, fim_model = "http://" .. home_pc .. ":10101/infill", "qwen2.5-coder-7b-fim"
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
