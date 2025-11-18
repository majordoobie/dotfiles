return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workplace",
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
				},
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					parameterNames = true,
					pytestParameters = true,
				},
			},
		},
	},
	root_markers = { "pyproject.toml", "requirements.txt" },
}
