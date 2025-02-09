-- lua/my_telescope_picker.lua
local M = {}

-- This function accepts either:
--   1. A table of strings, e.g. { "path/to/file1", "path/to/file2", ... }
--   2. A table with an "items" field where each item is a table with a "value" key.
--      For example: { items = { { value = "path/to/file1" }, { value = "path/to/file2" } } }
function M.toggle_telescope(paths)
	local conf = require("telescope.config").values
    local file_paths = {}

	if paths.items then
		-- Extract the values from the items table.
		for _, item in ipairs(paths.items) do
			table.insert(file_paths, item.value)
		end
	else
		-- Assume the table is already a list of strings.
		file_paths = paths
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Visited Paths",
			layout_strategy = "vertical",
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
		})
		:find()
end

return M
