-- Align GitLab/GFM pipe tables in place.
--
-- Self-contained: no plugin dependency. Produces the same layout prettier
-- does -- columns padded to their widest cell, delimiter row filled with
-- dashes, and cell contents justified according to the column's alignment
-- markers (:--- left, :---: center, ---: right).

local M = {}

local MIN_DASHES = 3

-- Split a table row on unescaped pipes. Per the GFM spec, `\|` is the only
-- escape -- a pipe inside a code span still splits the cell.
---@param line string
---@return string[]
local function split_cells(line)
	local cells, buf, i = {}, {}, 1
	while i <= #line do
		local ch = line:sub(i, i)
		if ch == "\\" and line:sub(i + 1, i + 1) == "|" then
			buf[#buf + 1] = "\\|"
			i = i + 2
		elseif ch == "|" then
			cells[#cells + 1] = table.concat(buf)
			buf = {}
			i = i + 1
		else
			buf[#buf + 1] = ch
			i = i + 1
		end
	end
	cells[#cells + 1] = table.concat(buf)
	-- Rows are fenced by pipes, so drop the empty fields either side.
	if #cells > 0 and vim.trim(cells[1]) == "" then
		table.remove(cells, 1)
	end
	if #cells > 0 and vim.trim(cells[#cells]) == "" then
		table.remove(cells)
	end
	return vim.tbl_map(vim.trim, cells)
end

---@param cell string a delimiter cell such as ":---:"
---@return "left"|"center"|"right"|"none"
local function alignment(cell)
	local left, right = cell:sub(1, 1) == ":", cell:sub(-1) == ":"
	if left and right then
		return "center"
	elseif right then
		return "right"
	elseif left then
		return "left"
	end
	return "none"
end

---@param text string
---@param width integer
---@param align string
---@return string
local function justify(text, width, align)
	local pad = width - vim.fn.strdisplaywidth(text)
	if pad <= 0 then
		return text
	end
	if align == "right" then
		return string.rep(" ", pad) .. text
	elseif align == "center" then
		local left = math.floor(pad / 2)
		return string.rep(" ", left) .. text .. string.rep(" ", pad - left)
	end
	return text .. string.rep(" ", pad)
end

-- A delimiter row is made only of pipes, dashes, colons and spaces.
---@param line string
---@return boolean
local function is_delimiter(line)
	return line:match("^[|%-:%s]+$") ~= nil and line:find("%-") ~= nil
end

---@param lines string[] raw lines of one pipe table
---@return string[]
function M.align(lines)
	local rows, delim_idx = {}, nil
	for i, line in ipairs(lines) do
		rows[i] = split_cells(line)
		if delim_idx == nil and i > 1 and is_delimiter(line) then
			delim_idx = i
		end
	end
	if not delim_idx then
		return lines
	end

	local aligns = vim.tbl_map(alignment, rows[delim_idx])

	-- Column widths come from every row except the delimiter, which is filled
	-- to match rather than measured.
	local widths = {}
	for i, cells in ipairs(rows) do
		if i ~= delim_idx then
			for col, cell in ipairs(cells) do
				widths[col] = math.max(widths[col] or 0, vim.fn.strdisplaywidth(cell))
			end
		end
	end
	for col = 1, #aligns do
		local extra = (aligns[col] == "center" and 2) or (aligns[col] ~= "none" and 1) or 0
		widths[col] = math.max(widths[col] or 0, MIN_DASHES + extra)
	end

	local out = {}
	for i, cells in ipairs(rows) do
		local parts = {}
		for col = 1, #widths do
			if i == delim_idx then
				local align = aligns[col]
				local left = align == "left" or align == "center"
				local right = align == "right" or align == "center"
				local dashes = widths[col] - (left and 1 or 0) - (right and 1 or 0)
				parts[col] = (left and ":" or "") .. string.rep("-", dashes) .. (right and ":" or "")
			else
				parts[col] = justify(cells[col] or "", widths[col], aligns[col])
			end
		end
		out[i] = "| " .. table.concat(parts, " | ") .. " |"
	end
	return out
end

-- Align every pipe table in the buffer. Returns how many were changed.
---@param bufnr integer?
---@return integer
function M.align_buffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	if not ok or not parser then
		return 0
	end

	local ranges = {}
	local query = vim.treesitter.query.parse("markdown", "(pipe_table) @table")
	for _, tree in ipairs(parser:parse() or {}) do
		for _, node in query:iter_captures(tree:root(), bufnr) do
			local srow, _, erow, ecol = node:range()
			ranges[#ranges + 1] = { srow, ecol > 0 and erow + 1 or erow }
		end
	end

	-- Apply bottom-up so earlier ranges keep their line numbers.
	table.sort(ranges, function(a, b)
		return a[1] > b[1]
	end)

	local changed = 0
	for _, range in ipairs(ranges) do
		local lines = vim.api.nvim_buf_get_lines(bufnr, range[1], range[2], false)
		local aligned = M.align(lines)
		if not vim.deep_equal(lines, aligned) then
			vim.api.nvim_buf_set_lines(bufnr, range[1], range[2], false, aligned)
			changed = changed + 1
		end
	end
	return changed
end

return M
