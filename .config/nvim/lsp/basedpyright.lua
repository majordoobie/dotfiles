return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				typeCheckingMode = "basic",
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				-- Keep auto-import suggestions in completion (blink.cmp via basedpyright)
				autoImportCompletions = true,
				diagnosticSeverityOverrides = {
					reportUnusedCallResult = "none",
					reportExplicitAny = "none",
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
					reportAny = "none",
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
