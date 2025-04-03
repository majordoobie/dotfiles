return {
	cmd = {
		"clangd",
		"--background-index", -- Keep indexing in the bakcground
		"--clang-tidy", -- Enables clang-tidy diagnostics
		"--fallback-style=google", -- Default style if .clang-tidy is not found
		"--header-insertion=iwyu", -- include what you use
		"--enable-config", -- Enables clangd to read project .clang-tidy file
		"--log=verbose",
		"--compile-commands-dir=build",
	},
	filetypes = { "c", "cpp", "h" },
	root_markers = { ".clangd", "compile_commands.json", ".clang-tidy" },
}
