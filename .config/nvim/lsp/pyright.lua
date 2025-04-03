return {
	cmd = { "pyright-langserver", "--stdio" }, -- Example command
	filetypes = { "python" },
	settings = {
		python = {},
	},
	root_markers = { "pyproject.toml", "requirements.txt" },
}
