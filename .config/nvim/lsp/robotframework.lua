-- [[
-- robotcode: Language server, debugger and CLI tools for Robot Framework.
-- https://github.com/robotcodedev/robotcode
--
-- Install: uv tool install 'robotcode[languageserver]'
-- The [languageserver] extra is required -- the bare package ships the CLI only.
--
-- Replaces robotframework-lsp (robocorp), which had no release after Oct 2024.
--
-- NOTE: uv tool install isolates robotcode in its own venv, so it sees only the
-- robotframework pulled in transitively -- not SeleniumLibrary or project keyword
-- libraries. Builtin keywords resolve; project imports will not. To get those,
-- install into the project venv instead and point cmd at that binary.
-- ]]
return {
	cmd = { "robotcode", "language-server" },
	filetypes = { "robot" },
	root_markers = { "robot.toml", ".robot.toml", "pyproject.toml", ".git" },
}
