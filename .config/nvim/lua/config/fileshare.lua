-- Shared helpers for copying prebuilt plugin binaries from the air-gapped fileshare.
-- Used by plugin configs that ship native libraries (blink.cmp, codediff, etc.).

local M = {}

local FILESHARE_ROOT = vim.env.NVIM_FILESHARE_ROOT or "/mnt/software/Neovim"

function M.fileshare_root()
	return FILESHARE_ROOT
end

function M.is_airgapped()
	return vim.fn.isdirectory(FILESHARE_ROOT) == 1
end

-- Returns the exact git tag a repo's HEAD points at (e.g. "v2.43.10"), or nil.
-- Plugins ship native binaries whose ABI is tied to the tag, so the match must be exact.
function M.get_exact_tag(repo_path)
	if vim.fn.isdirectory(repo_path .. "/.git") == 0 then
		return nil
	end
	local result = vim.system({ "git", "describe", "--tags", "--exact-match" }, { cwd = repo_path }):wait()
	if result.code ~= 0 then
		return nil
	end
	return vim.trim(result.stdout)
end

-- Copy a tag-matched prebuilt binary from the fileshare into a plugin directory.
--
-- opts fields:
--   name        (string)                    — display label used in user-facing messages
--   plugin_path (string)                    — absolute path to the installed plugin
--   subdir      (string)                    — fileshare subdirectory holding the binaries
--   source_tmpl (string)                    — filename template, uses %s for the tag
--   dest        (function(tag) -> string)   — returns the absolute destination path
--   post        (function(tag, plugin_path))— optional, runs after a successful copy
--
-- Returns true on success, false on any failure (with a user-visible reason).
function M.copy_tag_matched_binary(opts)
	local tag = M.get_exact_tag(opts.plugin_path)
	if tag == nil then
		vim.api.nvim_echo({
			{ "⚠️  " .. opts.name .. ": plugin is not on a git tag, cannot pick a matching fileshare binary", "WarningMsg" },
		}, true, {})
		return false
	end

	local subdir = FILESHARE_ROOT .. "/" .. opts.subdir
	local source = subdir .. "/" .. opts.source_tmpl:format(tag)
	if not vim.uv.fs_stat(source) then
		local available = vim.fn.glob(subdir .. "/" .. opts.source_tmpl:format("*"), false, true)
		vim.api.nvim_echo({
			{ "⚠️  " .. opts.name .. ": no binary for " .. tag .. " on fileshare (" .. source .. ")\n", "WarningMsg" },
			{ "    Available: " .. (#available > 0 and table.concat(available, ", ") or "(none)"), "WarningMsg" },
		}, true, {})
		return false
	end

	local dest = opts.dest(tag)
	vim.fn.mkdir(vim.fs.dirname(dest), "p")
	vim.api.nvim_echo({ { "Copying " .. opts.name .. " " .. tag .. " binary from fileshare...", "WarningMsg" } }, true, {})
	vim.cmd("redraw")
	local ok, err = vim.uv.fs_copyfile(source, dest)
	if not ok then
		vim.api.nvim_echo({
			{ "⚠️  " .. opts.name .. ": copy failed: " .. tostring(err), "ErrorMsg" },
		}, true, {})
		return false
	end

	if opts.post then
		opts.post(tag, opts.plugin_path)
	end

	vim.api.nvim_echo({ { "✅ " .. opts.name .. " " .. tag .. " binary copied from fileshare!", "Normal" } }, true, {})
	return true
end

return M
