-- [[
-- ty: An extremely fast Python type checker and language server, written in Rust.
-- https://github.com/astral-sh/ty
--
-- Install: uv tool install ty
-- ]]
return {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
}
