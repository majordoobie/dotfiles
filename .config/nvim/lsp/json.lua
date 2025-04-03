-- [[
--      npm install vscode-langservers-extracted
-- ]]
return {
	cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
}
