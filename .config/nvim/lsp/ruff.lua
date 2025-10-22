return {
	cmd = { "ruff", "server", "--preview" },
	filetypes = { "python" },
	-- Configuration for the Ruff language server
	init_options = {
		settings = {
			-- Path to your global Ruff configuration file
			-- This will be used as a fallback if no project-specific config exists
			configuration = "~/.config/ruff/ruff.toml",
		},
	},
	root_markers = { "pyproject.toml", "requirements.txt", "setup.py", "setup.cfg", ".git" },
	-- Disable hover in favor of Pyright
	on_attach = function(client, bufnr)
		-- Disable hover capability - let Pyright handle it
		client.server_capabilities.hoverProvider = false
	end,
}
