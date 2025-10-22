return {
	cmd = { "pyright-langserver", "--stdio" }, -- Example command
	filetypes = { "python" },
	settings = {
		pyright = {
			-- Let Ruff handle import organization
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				-- typeCheckingMode = "strict", -- enable all type hint features
				diagnosticMode = "workplace", -- see all errors in project
				useLibraryCodeForTypes = true, -- "Parse the lib for type info
				autoImportCompletions = true, -- get lsp to provide suggestions for import
				-- Disable import/unused variable warnings since Ruff handles these
				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
				},
			},
		},
	},
	root_markers = { "pyproject.toml", "requirements.txt" },
}
