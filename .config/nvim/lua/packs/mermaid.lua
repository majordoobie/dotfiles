--- Mermaid support that works on the air-gapped box.
---
--- Deliberately plugin-free. The usual Neovim mermaid plugins (diagram.nvim,
--- nvim-inline-markdown) need image.nvim plus a kitty-graphics terminal, which is not a
--- safe assumption inside WSL. These commands shell out to two binaries git-sync already
--- migrates instead:
---
---   mermaid-ascii  statically linked Go binary, renders into a normal buffer. No shared
---                  libraries, no node, no browser — this is why preview works anywhere.
---   mermaid-lint   node + jsdom validator. Full grammar check with no browser at all.
---   mmdc           only for svg/png export; needs the system Chrome (see CHROME below).
---
--- Commands:
---   :MermaidPreview        ASCII render of the buffer / fence under the cursor
---   :MermaidLint           validate, results into the quickfix list
---   :MermaidExport [fmt]   mmdc export next to the file (svg default, or png/pdf)

local M = {}

-- Chrome lives at a predictable path once the .deb is installed; mmdc needs to be told
-- because the bundle intentionally ships without puppeteer's own ~283MB Chrome.
local CHROME_CANDIDATES = {
	"/usr/bin/google-chrome",
	"/usr/bin/google-chrome-stable",
	"/usr/bin/chromium",
	"/usr/bin/chromium-browser",
	"/opt/google/chrome/chrome",
}

local function executable(name)
	return vim.fn.executable(name) == 1
end

local function find_chrome()
	if vim.env.PUPPETEER_EXECUTABLE_PATH and vim.uv.fs_stat(vim.env.PUPPETEER_EXECUTABLE_PATH) then
		return vim.env.PUPPETEER_EXECUTABLE_PATH
	end
	for _, path in ipairs(CHROME_CANDIDATES) do
		if vim.uv.fs_stat(path) then
			return path
		end
	end
	return nil
end

--- Return the mermaid source for the current buffer, plus the line it starts on.
--- In markdown, take the ```mermaid fence surrounding the cursor; elsewhere take the
--- whole buffer. The start line is what lets :MermaidLint report real file positions.
local function current_diagram()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local ft = vim.bo.filetype

	if ft ~= "markdown" and ft ~= "mdx" then
		return lines, 1
	end

	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	local open_pat = "^%s*```+%s*mermaid"
	local close_pat = "^%s*```+%s*$"

	local start_idx = nil
	for i = cursor, 1, -1 do
		if lines[i]:match(open_pat) then
			start_idx = i
			break
		end
		-- A closing fence above the cursor means the cursor is not inside a block.
		if i < cursor and lines[i]:match(close_pat) then
			break
		end
	end
	if not start_idx then
		return nil, nil
	end

	local body = {}
	for i = start_idx + 1, #lines do
		if lines[i]:match(close_pat) then
			break
		end
		table.insert(body, lines[i])
	end

	-- Strip the common indent so fences nested in list items still parse.
	local indent = math.huge
	for _, l in ipairs(body) do
		if l:match("%S") then
			indent = math.min(indent, #l:match("^%s*"))
		end
	end
	if indent > 0 and indent < math.huge then
		for i, l in ipairs(body) do
			body[i] = l:sub(indent + 1)
		end
	end

	return body, start_idx + 1
end

local function float(lines, title)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	local width, height = 0, #lines
	for _, l in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end
	width = math.min(math.max(width + 2, 30), math.floor(vim.o.columns * 0.9))
	height = math.min(math.max(height, 3), math.floor(vim.o.lines * 0.85))

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " " .. title .. " ",
		title_pos = "center",
	})
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
	return buf
end

function M.preview()
	if not executable("mermaid-ascii") then
		vim.notify("mermaid-ascii not found on PATH", vim.log.levels.ERROR)
		return
	end
	local body = current_diagram()
	if not body or #body == 0 then
		vim.notify("No mermaid diagram here (cursor not inside a ```mermaid fence?)", vim.log.levels.WARN)
		return
	end

	-- vim.system raises rather than returning a code when the exec itself fails (wrong
	-- architecture, missing interpreter), so keep that out of the user's face.
	local spawned, result = pcall(function()
		return vim
			.system({ "mermaid-ascii", "--file", "/dev/stdin" }, {
				stdin = table.concat(body, "\n") .. "\n",
				text = true,
			})
			:wait()
	end)
	if not spawned then
		vim.notify("could not run mermaid-ascii: " .. tostring(result), vim.log.levels.ERROR)
		return
	end

	if result.code ~= 0 then
		local err = (result.stderr ~= "" and result.stderr or result.stdout)
		vim.notify("mermaid-ascii failed:\n" .. err, vim.log.levels.ERROR)
		return
	end

	float(vim.split(result.stdout:gsub("%s+$", ""), "\n", { plain = true }), "mermaid")
end

function M.lint()
	if not executable("mermaid-lint") then
		vim.notify("mermaid-lint not found on PATH", vim.log.levels.ERROR)
		return
	end
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Buffer has no file to lint", vim.log.levels.WARN)
		return
	end

	local spawned, result = pcall(function()
		return vim.system({ "mermaid-lint", "--json", file }, { text = true }):wait()
	end)
	if not spawned then
		vim.notify("could not run mermaid-lint: " .. tostring(result), vim.log.levels.ERROR)
		return
	end

	local ok, report = pcall(vim.json.decode, result.stdout)
	if not ok or type(report) ~= "table" then
		vim.notify("mermaid-lint gave no parsable report:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
		return
	end

	local items = {}
	for _, r in ipairs(report.results or {}) do
		if not r.ok then
			table.insert(items, { filename = r.file, lnum = r.line, col = 1, text = r.error, type = "E" })
		end
	end

	vim.fn.setqflist({}, "r", { title = "mermaid-lint", items = items })
	if #items == 0 then
		vim.notify(string.format("mermaid: %d diagram(s) valid", report.checked or 0), vim.log.levels.INFO)
	else
		vim.cmd("copen")
		vim.notify(string.format("mermaid: %d invalid diagram(s)", #items), vim.log.levels.WARN)
	end
end

function M.export(fmt)
	fmt = (fmt ~= "" and fmt) or "svg"
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Save the buffer before exporting", vim.log.levels.WARN)
		return
	end

	local chrome = find_chrome()
	if not chrome then
		vim.notify(
			"No Chrome found for mmdc. Set PUPPETEER_EXECUTABLE_PATH or install google-chrome.",
			vim.log.levels.ERROR
		)
		return
	end

	-- mmdc ships as a node script in the migrated bundle rather than a PATH binary,
	-- so prefer the wrapper if it exists and fall back to invoking the cli directly.
	local cmd
	if executable("mmdc") then
		cmd = { "mmdc" }
	else
		local cli = vim.fn.expand("~/.local/lib/node_modules/@mermaid-js/mermaid-cli/src/cli.js")
		if not vim.uv.fs_stat(cli) then
			vim.notify("mmdc not found (looked for mmdc on PATH and " .. cli .. ")", vim.log.levels.ERROR)
			return
		end
		cmd = { "node", cli }
	end

	-- Chrome refuses to start as root / under some WSL setups without --no-sandbox.
	local cfg = vim.fn.tempname() .. ".json"
	vim.fn.writefile({ '{"args":["--no-sandbox","--disable-gpu","--disable-dev-shm-usage"]}' }, cfg)

	local out = vim.fn.fnamemodify(file, ":r") .. "." .. fmt
	vim.list_extend(cmd, { "-i", file, "-o", out, "-p", cfg })

	vim.notify("mermaid: exporting to " .. vim.fn.fnamemodify(out, ":t") .. " ...", vim.log.levels.INFO)
	vim.system(cmd, { text = true, env = { PUPPETEER_EXECUTABLE_PATH = chrome } }, function(result)
		vim.schedule(function()
			os.remove(cfg)
			if result.code == 0 then
				vim.notify("mermaid: wrote " .. out, vim.log.levels.INFO)
			else
				local err = (result.stderr ~= "" and result.stderr or result.stdout)
				vim.notify("mmdc failed:\n" .. err, vim.log.levels.ERROR)
			end
		end)
	end)
end

vim.api.nvim_create_user_command("MermaidPreview", M.preview, { desc = "ASCII preview of mermaid diagram" })
vim.api.nvim_create_user_command("MermaidLint", M.lint, { desc = "Validate mermaid diagrams into quickfix" })
vim.api.nvim_create_user_command("MermaidExport", function(opts)
	M.export(opts.args)
end, { nargs = "?", complete = function()
	return { "svg", "png", "pdf" }
end, desc = "Export mermaid diagram via mmdc" })

vim.keymap.set("n", "<leader>mp", M.preview, { desc = "Mermaid preview (ascii)" })
vim.keymap.set("n", "<leader>ml", M.lint, { desc = "Mermaid lint" })
vim.keymap.set("n", "<leader>me", function()
	M.export("svg")
end, { desc = "Mermaid export svg" })

-- .mmd/.mermaid are not in Neovim's default filetype table.
vim.filetype.add({ extension = { mmd = "mermaid", mermaid = "mermaid" } })

return M
