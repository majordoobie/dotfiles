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
  local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
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

function M.get_venv_name()
	local venv_path = require("venv-selector").venv()
	if not venv_path or venv_path == "" then
		return ""
	end

	local venv_name = vim.fn.fnamemodify(venv_path, ":t")
	if not venv_name then
		return ""
	end

	local output = "🐍 [" .. venv_name .. "]"
	return output
end

function M.bubble_theme()
	return {
		mocha_rosewater = "#f5e0dc",
		mocha_flamingo = "#f2cdcd",
		mocha_mauve = "#cba6f7",
		mocha_red = "#f38ba8",
		mocha_maroon = "#eba0ac",
		mocha_peach = "#fab387",
		mocha_yellow = "#f9e2af",
		mocha_green = "#a6e3a1",
		mocha_teal = "#94e2d5",
		mocha_sky = "#89dceb",
		mocha_sapphire = "#74c7ec",
		mocha_blue = "#89b4fa",
		mocha_lavender = "#b4befe",
		mocha_text = "#cdd6f4",
		mocha_subtext1 = "#bac2de",
		mocha_subtext0 = "#a6adc8",
		mocha_overlay2 = "#9399b2",
		mocha_overlay1 = "#7f849c",
		mocha_overlay0 = "#6c7086",
		mocha_surface2 = "#585b70",
		mocha_surface1 = "#45475a",
		mocha_surface0 = "#313244",
		mocha_base = "#1e1e2e",
		mocha_mantle = "#181825",
		mocha_crust = "#11111b",
	}
end

return M
