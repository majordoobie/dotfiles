local M = {}

function M.truncate_branch_name(branch_name)
	local max_length = 20
	if #branch_name > max_length then
		return branch_name:sub(1, max_length) .. "..."
	else
		return branch_name
	end
end

function M.get_lsp_client_name()
	local msg = "No Active LSP"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_clients()
	if next(clients) == nil then
		return msg
	end

	for _, client in ipairs(clients) do
		if client.config.filetypes and vim.fn.index(client.config.filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return msg
end

return M
