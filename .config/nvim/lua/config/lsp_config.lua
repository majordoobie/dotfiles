-- Set LSP log level to WARN to avoid performance issues
vim.lsp.log.set_level("WARN")

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Set explicit position encoding to avoid warnings with multiple LSP servers
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16", "utf-8" }

-- Enable inlay hints capability
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.inlayHint = {
	dynamicRegistration = true,
	resolveSupport = {
		properties = { "tooltip", "textEdits", "label.tooltip", "label.location", "label.command" },
	},
}

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

-- Enables languages in ../lsp/
vim.lsp.enable({
	"asm",
	-- "basedpyright", -- disabled, using ty instead
	"ty",
	"bash",
	"clangd",
	"cmake",
	"docker_compose",
	"html",
	"json",
	"lua",
	"nix",
	"robotframework",
	"ruff",
	"yaml",
	"toml",
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
	callback = function(args)
		local bufnr = args.buf
		-- Enable inlay hints when LSP attaches
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

		-- Also try enabling without explicit buffer
		pcall(function()
			vim.lsp.inlay_hint.enable(true)
		end)

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
		-- Use native definition jump to avoid position_encoding warnings
		map("<leader>jd", vim.lsp.buf.definition, "📍 Jump to definition")
		map("<leader>jE", telescope.diagnostics, "🚨 All diagnostics (workspace)")
		map("<leader>jS", telescope.lsp_document_symbols, "📑 Document symbols")
		map("<leader>jA", telescope.lsp_workspace_symbols, "🌍 Workspace symbols")
		-- Use native references to avoid position_encoding warnings
		map("<leader>jr", telescope.lsp_references, "🔗 View references")
		-- Use native incoming calls to avoid position_encoding warnings
		map("<leader>ji", vim.lsp.buf.incoming_calls, "📞 Incoming calls")
		-- Use native implementation jump to avoid position_encoding warnings
		map("<leader>jD", vim.lsp.buf.implementation, "⚙️  Jump to implementation")

		map("<leader>je", function()
			telescope.diagnostics({ bufnr = 0 })
		end, "⚠️  Buffer diagnostics")

		map("<leader>js", function()
			telescope.lsp_document_symbols({ symbols = { "function", "method", "struct", "enum" } })
		end, "🔖 Filter symbols")
	end,
})
