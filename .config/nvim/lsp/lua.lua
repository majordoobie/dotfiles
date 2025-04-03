-- [[
--      Get tar from: https://luals.github.io/#neovim-install
-- ]]
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
				library = {
					"${3rd/luv/library}",
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
