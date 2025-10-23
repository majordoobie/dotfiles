local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

-- Enables languages in ../lsp/
vim.lsp.enable({
	"asm",
	"bash",
	"clangd",
	"cmake",
	"docker_compose",
	"html",
	"json",
	"lua",
	"nix",
	"pyright",
	"robotframework",
	"ruff",
	"yaml",
})

-- [[
-- Configure diagnostic messaging
-- ]]
vim.diagnostic.config({
	virtual_text = { current_line = true },
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = "󰠠 ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	-- When calling vim.diagnostic.open_float()
	float = {
		border = "rounded",
		source = "if_many",
	},
})

-- [[
-- Configure keymaps when a LSP server attaches to the current buffer
-- ]]
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(_, bufnr)
		-- [[
		-- <leader>e -- Make a physical LSP change
		-- <leader>j -- jump/view LSP information
		-- ]]
		--

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, silent = true, desc = "[LSP] " .. desc })
		end

		-- ══════════════════════════════════════════════════════════════
		-- 🔧 LSP Actions
		-- ══════════════════════════════════════════════════════════════
		map("<leader>er", vim.lsp.buf.rename, "✏️  Rename symbol")
		map("K", vim.lsp.buf.hover, "📖 Show documentation")

		map("D", function()
			local virt_line_setting = vim.diagnostic.config().virtual_lines
			if virt_line_setting == false or virt_line_setting.current_line == false then
				vim.diagnostic.config({ virtual_lines = { current_line = true } })
			else
				vim.diagnostic.config({ virtual_lines = false })
			end
		end, "🔄 Toggle virtual lines")

		map("<leader>jl", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "⏭️  Next diagnostic")
		map("<leader>jh", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "⏮️  Previous diagnostic")
		map("<leader>vd", function()
			vim.diagnostic.open_float()
		end, "🔍 View diagnostic popup")

		map("<leader>ee", vim.lsp.buf.code_action, "💡 Code actions")

		-- ══════════════════════════════════════════════════════════════
		-- 🔭 Telescope LSP Functions
		-- ══════════════════════════════════════════════════════════════
		local telescope = require("telescope.builtin")
		map("<leader>jd", telescope.lsp_definitions, "📍 Jump to definition")
		map("<leader>jE", telescope.diagnostics, "🚨 All diagnostics (workspace)")
		map("<leader>jS", telescope.lsp_document_symbols, "📑 Document symbols")
		map("<leader>jA", telescope.lsp_workspace_symbols, "🌍 Workspace symbols")
		map("<leader>jr", telescope.lsp_references, "🔗 View references")
		map("<leader>ji", telescope.lsp_incoming_calls, "📞 Incoming calls")
		map("<leader>jD", telescope.lsp_implementations, "⚙️  Jump to implementation")

		map("<leader>je", function()
			telescope.diagnostics({ bufnr = 0 })
		end, "⚠️  Buffer diagnostics")

		map("<leader>js", function()
			telescope.lsp_document_symbols({ symbols = { "function", "method", "struct", "enum" } })
		end, "🔖 Filter symbols")
	end,
})
