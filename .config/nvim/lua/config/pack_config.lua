--- GitHub URL shorthand for vim.pack specs.
--- Usage: git_source("user/repo") returns "https://github.com/user/repo"
_G.git_source = function(x)
	return "https://github.com/" .. x
end

--- Display all vim.pack managed plugins in a centered floating window.
--- Shows name, source, version, revision, path, and active status for each plugin.
--- Press 'q' to close the window.
vim.keymap.set("n", "<leader>pl", function()
	local plugins = vim.pack.get()
	table.sort(plugins, function(a, b)
		return a.spec.name < b.spec.name
	end)

	local lines = { "Installed Plugins (" .. #plugins .. ")", "" }
	for _, p in ipairs(plugins) do
		table.insert(lines, p.spec.name)
		table.insert(lines, "  src:     " .. p.spec.src)
		if p.spec.version then
			table.insert(lines, "  version: " .. tostring(p.spec.version))
		end
		table.insert(lines, "  rev:     " .. p.rev)
		table.insert(lines, "  path:    " .. p.path)
		table.insert(lines, "  active:  " .. tostring(p.active))
		table.insert(lines, "")
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "markdown"

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " vim.pack ",
		title_pos = "center",
	})

	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end, { desc = "List installed plugins" })

--- Find and delete orphaned plugins (on disk but not active in current session).
--- Prompts for confirmation before deleting.
vim.keymap.set("n", "<leader>pd", function()
	local orphans = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()

	if #orphans == 0 then
		vim.notify("No orphaned plugins found", vim.log.levels.INFO)
		return
	end

	vim.notify("Orphaned plugins:\n" .. table.concat(orphans, "\n"), vim.log.levels.WARN)
	vim.ui.select({ "Yes", "No" }, { prompt = "Delete " .. #orphans .. " orphaned plugin(s)?" }, function(choice)
		if choice == "Yes" then
			vim.pack.del(orphans, { force = true })
			vim.notify("Deleted: " .. table.concat(orphans, ", "), vim.log.levels.INFO)
		end
	end)
end, { desc = "Delete orphaned plugins" })

--- Open the vim.pack update confirmation buffer to review and apply plugin updates.
vim.keymap.set("n", "<leader>pu", function()
	vim.pack.update()
end, { desc = "Update plugins" })
