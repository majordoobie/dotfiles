-- [[
-- npm install @microsoft/compose-language-service
--
-- You might have to manually set the file type with :set filetype=yaml.docker-compose
--
-- Or just add the following to your configs
-- vim.filetype.add({
--     pattern = {
--         ["compose.*%.ya?ml"] = "yaml.docker-compose",
--         ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
--     },
-- })
-- ]]

return {
	cmd = { "docker-compose-langserver", "--stdio" },
	filetypes = { "yaml.docker-compose" },
}
