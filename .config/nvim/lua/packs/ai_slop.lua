--[[
CodeCompanion / OpenCode flow
-----------------------------

This config uses CodeCompanion as the Neovim UI and OpenCode as the backend
agent adapter.

Flow:

  Neovim
    -> CodeCompanion.nvim
    -> OpenCode ACP adapter
    -> OpenCode config/provider setup
    -> OpenWebUI / internal OpenAI-compatible endpoint
    -> Qwen model

CodeCompanion provides the editor integration: chat buffer, inline prompts,
buffer context like #{buffer}, visual-selection context, and Neovim commands.

OpenCode provides the agent layer: it reads the existing OpenCode configuration,
selects the configured provider/model, handles tool behavior, and applies the
same permissions/rules used by the normal `opencode` CLI workflow.

This means the AI is not connected directly from CodeCompanion to the LLM in
this setup. CodeCompanion talks to OpenCode, and OpenCode talks to the model.

Practical usage:

  <leader>a          Toggle the CodeCompanion chat
  <leader>A          Open CodeCompanion actions
  ga                 In visual mode, add the selection to chat
  #{buffer}          Include the current buffer as context
  ga                 Change adapter/model inside the chat
  <C-s>              Send message from insert mode
  <CR>               Send message from normal mode
  ?                  Show chat keymaps/options
  #                  Add editor context, like #{buffer}
  @                  Add tools
  /                  Slash commands
  \                  ACP/OpenCode commands when available
  gd                 Debug the message/context payload
  gbd                Sync current buffer diff each turn
  gba                Sync full current buffer each turn
  gr                 Regenerate last response
  gx                 Clear chat
  gm                 Send a "btw" message while tool calls are running

To send the current file to the model, type #{buffer} anywhere in the chat
prompt, for example:

  Explain #{buffer}.
  Review #{buffer} for behavior changes.

Use the OpenCode adapter for agentic coding tasks, repo inspection, and changes
that benefit from OpenCode's tools/permissions.
--]]

-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	git_source("olimorris/codecompanion.nvim"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════
require("codecompanion").setup({
	display = {
		chat = {
			fold_context = true,
			show_settings = true,
			show_header_separator = true,
			window = {
				layout = "vertical",
				full_height = true,
				position = nil,
				width = 0.5,
				opts = {
					wrap = false,
				},
			},
		},
	},
	interactions = {
		chat = {
			adapter = {
				-- Connect CodeCompanion to OpenCode by launching `opencode acp`.
				name = "opencode",
				model = "owui/122B-Q8",
			},
			roles = {
				user = "User Prompt...",
			},
		},
		background = {
			chat = {
				opts = {
					enabled = false,
				},
			},
		},
	},
})

local ui_utils = require("codecompanion.utils.ui")
local api = vim.api
local wait_ns_prefix = "codecompanion_waiting_llm_"

local function show_waiting(bufnr)
	if not (bufnr and api.nvim_buf_is_valid(bufnr)) then
		return
	end
	ui_utils.show_buffer_notification(bufnr, {
		namespace = wait_ns_prefix .. tostring(bufnr),
		footer = true,
		text = "Waiting for model response …",
		main_hl = "CodeCompanionChatWarn",
		sub_hl = "CodeCompanionChatSubtext",
	})
end

local function clear_waiting(bufnr)
	if not (bufnr and api.nvim_buf_is_valid(bufnr)) then
		return
	end
	ui_utils.clear_notification(bufnr, { namespace = wait_ns_prefix .. tostring(bufnr) })
end

api.nvim_create_autocmd("User", {
	pattern = "CodeCompanionChatSubmitted",
	callback = function(ev)
		show_waiting(ev.data and ev.data.bufnr or nil)
	end,
})

api.nvim_create_autocmd("User", {
	pattern = {
		"CodeCompanionChatDone",
		"CodeCompanionChatStopped",
		"CodeCompanionChatClosed",
		"CodeCompanionChatCleared",
	},
	callback = function(ev)
		clear_waiting(ev.data and ev.data.bufnr or nil)
	end,
})

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
vim.keymap.set(
	"n",
	"<leader>a",
	":CodeCompanionChat Toggle<cr>",
	{ desc = "Toggle AI Chat", noremap = true, silent = true }
)

vim.keymap.set(
	{ "n", "v" },
	"<leader>A",
	":CodeCompanionActions<cr>",
	{ desc = "AI Actions", noremap = true, silent = true }
)

vim.keymap.set(
	"v",
	"ga",
	":CodeCompanionChat Add<cr>",
	{ desc = "Add selection to AI Chat", noremap = true, silent = true }
)

vim.cmd([[cab cc CodeCompanion]])
