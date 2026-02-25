return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("codecompanion").setup({
			display = {
				chat = {
					show_settings = true,
					show_header_separator = true,
					window = {
						layout = "float",
						border = "rounded",
						width = 0.7,
						height = 0.8,
						opts = {
							wrap = false,
						},
					},
				},
			},
			interactions = {
				chat = {
					adapter = {
						name = "claude_code",
					},
				},
				inline = {
					adapter = {
						name = "claude_code",
					},
				},
				background = {
					adapter = {
						name = "claude_code",
					},
				},
				cmd = {
					adapter = {
						name = "claude_code",
					},
				},
			},
			adapters = {
				acp = {
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							env = {
								CLAUDE_CODE_OAUTH_TOKEN = vim.fn.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
							},
						})
					end,
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

		vim.keymap.set(
			"n",
			"<leader>a",
			":CodeCompanionChat Toggle<cr>",
			{ desc = "Toggle AI Chat", noremap = true, silent = true }
		)
	end,
}
