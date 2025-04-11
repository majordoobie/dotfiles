local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

-- Enables languages in ../lsp/
vim.lsp.enable({
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
	"yaml",
	"asm",
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

		-- Builtin
		map("<leader>er", vim.lsp.buf.rename, "rename")
		map("K", vim.lsp.buf.hover, "show docs")
		map("D", function()
			local virt_line_setting = vim.diagnostic.config().virtual_lines
			if virt_line_setting == false or virt_line_setting.current_line == false then
				vim.diagnostic.config({ virtual_lines = { current_line = true } })
			else
				vim.diagnostic.config({ virtual_lines = false })
			end
		end, "Toggle virtual lines")
		map("<leader>jl", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Goto next diagnostic")
		map("<leader>jh", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Goto prev diagnostic")
		map("<leader>ee", vim.lsp.buf.code_action, "show code actions")
		map("<leader>jd", vim.lsp.buf.definition, "jump to definition")

		--
		-- telescope LSP functions
		--
		local telescope = require("telescope.builtin")
		map("<leader>je", telescope.diagnostics, "view all diagnostic messages in the current buffer")
		map("<leader>jS", telescope.lsp_document_symbols, "View ALL symbols in the current file")
		map("<leader>jA", telescope.lsp_workspace_symbols, "View ALL symbols across project")
		map("<leader>jr", telescope.lsp_references, "View all the references")
		map("<leader>ji", telescope.lsp_incoming_calls, "View all incoming calls")
		map("<leader>jD", telescope.lsp_implementations, "Jump to implementation")
		map("<leader>js", function()
			telescope.lsp_document_symbols({ symbols = { "function", "method", "struct", "enum" } })
		end, "View symbols")
	end,
})
