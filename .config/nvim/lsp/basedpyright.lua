return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
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
