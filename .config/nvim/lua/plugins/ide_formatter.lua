--[[
Lua:
    cargo install stylua

Python:
    pip install black
    pip install isort

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
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "ruff" },
				nix = { "nixfmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
				c = { "clang-format" },
				json = { "prettierd" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			clang_format = {
				-- fallback to llvm style if not .clang-format file is found
				prepend_args = { "--style=file", "--fallback-style=LLVM" },
			},

			notify_on_error = true,
			notify_no_formatters = true,
			default_format_opts = {
				lsp_format = "fallback",
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>ef", conform.format, { desc = "Format File" })
	end,
}
