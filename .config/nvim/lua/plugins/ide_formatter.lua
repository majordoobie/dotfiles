--[[
Lua:
    cargo install stylua

Python:
    pip install ruff

C/C++:
    c/cpp (needs clangd, clang-tidy, and clang-check)
    ## Use the llvm script provided by clang to install clang so that we are not arch dependent
    RUN wget https://apt.llvm.org/llvm.sh;
    RUN chmod +x llvm.sh;
    RUN ./llvm.sh ${LLVM_VERSION} all;
    RUN rm llvm.sh;
    RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} 100;
    RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} 100;
    RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} 100;
    RUN update-alternatives --install /usr/bin/lldb-server lldb-server /usr/bin/lldb-server-${LLVM_VERSION} 100;

cmake:
    pip install cmakelang

json:
    brew install yq

yaml:
    yamlfmt

markdown:
    pip install mdformat

]]
--

return {
	"stevearc/conform.nvim",
	event = { "bufreadpre", "bufnewfile" },
	config = function()
		local conform = require("conform")

		-- Python helper for import organization via Ruff LSP.
		-- This runs only when <leader>ef is used (not on save).
		-- We intentionally use LSP code actions instead of the CLI formatter.
		local function organize_imports_with_ruff_lsp(bufnr)
			-- Build a whole-buffer range for the code-action request.
			local last_line = math.max(vim.api.nvim_buf_line_count(bufnr) - 1, 0)
			local params = {
				textDocument = vim.lsp.util.make_text_document_params(bufnr),
				range = {
					start = { line = 0, character = 0 },
					["end"] = { line = last_line, character = 0 },
				},
			}
			-- Ask only for Ruff's organize-imports action.
			params.context = { only = { "source.organizeImports.ruff" }, diagnostics = {} }

			-- Sync request so imports are organized before formatting starts.
			-- Timeout: 1500ms.
			local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1500)
			if not results then
				return
			end

			-- Ruff may return text edits and/or an execute-command action.
			-- Apply edits first, then execute commands using client request API.
			for client_id, result in pairs(results) do
				local client = vim.lsp.get_client_by_id(client_id)
				for _, action in pairs(result.result or {}) do
					if action.edit then
						vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
					end
					if action.command and client then
						-- action.command can be a command table or command string.
						-- If it is a string, fallback to the full action payload.
						local command = type(action.command) == "table" and action.command or action
						client:request_sync("workspace/executeCommand", command, 1500, bufnr)
					end
				end
			end
		end

		-- Main formatter entry used by <leader>ef.
		-- Python: organize imports via Ruff LSP, then run Conform formatters.
		-- Other filetypes: just run Conform formatters.
		local function format_with_conform_and_ruff_imports(opts)
			opts = opts or {}
			local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
			if vim.bo[bufnr].filetype == "python" then
				organize_imports_with_ruff_lsp(bufnr)
			end
			-- For Python, Conform runs: ruff_fix, then ruff_format.
			conform.format(opts)
		end

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- conform will run multiple formatters sequentially
				python = {
					-- To fix auto-fixable lint errors.
					"ruff_fix",
					-- To run the Ruff formatter.
					"ruff_format",
				},
				nix = { "nixfmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
				c = { "clang-format" },
				h = { "clang-format" },
				json = { "prettierd" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			clang_format = {
				-- fallback to llvm style if not .clang-format file is found
				prepend_args = { "--style=file", "--fallback-style=llvm" },
			},

			notify_on_error = true,
			notify_no_formatters = true,
			default_format_opts = {
				lsp_format = "fallback",
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>ef", format_with_conform_and_ruff_imports, { desc = "✨ Format file" })
	end,
}
