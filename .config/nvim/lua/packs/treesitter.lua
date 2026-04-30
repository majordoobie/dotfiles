-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

-- NOTE: :TSUpdate only exists on the classic branch. On main, parsers are
-- managed via require("nvim-treesitter").install(...) directly (see below),
-- so no PackChanged autocmd is needed.

local fileshare = require("config.fileshare")

vim.pack.add({
	{ src = git_source("nvim-treesitter/nvim-treesitter"), version = "main" },
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- Neovim 0.12 handles highlight/indent natively via vim.treesitter
-- nvim-treesitter now only manages parser installation
require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local languages = {
	"arduino",
	"asm",
	"bash",
	"c",
	"comment",
	"cpp",
	"cmake",
	"css",
	"csv",
	"diff",
	"disassembly",
	"dockerfile",
	"doxygen",
	"fish",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitignore",
	"go",
	"hcl",
	"html",
	"htmldjango",
	"http",
	"hjson",
	"ini",
	"java",
	"javascript",
	"json",
	"json5",
	"llvm",
	"lua",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"nix",
	"objdump",
	"proto",
	"python",
	"query",
	"requirements",
	"regex",
	"rust",
	"ssh_config",
	"sql",
	"terraform",
	"tmux",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"toml",
	"yaml",
	"zig",
}

local function tree_sitter_repo_name(url)
	return url:match("([^/]+)$"):gsub("%.git$", "")
end

local function read_trimmed_file(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local content = fd:read("*a")
	fd:close()
	if not content then
		return nil
	end
	return vim.trim(content)
end

local function parser_archive_root()
	return fileshare.fileshare_root() .. "/tree-sitter-lang-source-archives"
end

local function parser_stage_root()
	return vim.fn.stdpath("data") .. "/tree-sitter-lang-sources"
end

local function parser_archive_cache_root()
	return vim.fn.stdpath("cache") .. "/tree-sitter-lang-source-archives"
end

local parser_overrides = {}
local ts_install_running = false

local function ts_status(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Tree-sitter" })
	vim.api.nvim_echo({ { message, "Normal" } }, false, {})
	vim.cmd("redraw")
end

local function build_parser_registry(parsers)
	local archive_root = parser_archive_root()
	local stage_root = parser_stage_root()
	local registry = {}

	for _, lang in ipairs(languages) do
		local install_info = parsers[lang] and parsers[lang].install_info
		local url = install_info and install_info.url
		if type(url) == "string" then
			local repo = tree_sitter_repo_name(url)
			registry[lang] = {
				repo = repo,
				location = install_info.location,
				staged_path = stage_root .. "/" .. repo,
			}
		end
	end

	return archive_root, stage_root, registry
end

local function apply_parser_overrides(parsers)
	for lang, override in pairs(parser_overrides) do
		local install_info = parsers[lang] and parsers[lang].install_info
		if install_info then
			install_info.path = override.path
			install_info.revision = override.revision
		end
	end
end

local function parser_compile_path(detail, root)
	if detail.location and detail.location ~= "" then
		return root .. "/" .. detail.location
	end
	return root
end

local function parser_source_is_buildable(path)
	return vim.uv.fs_stat(path .. "/src/parser.c") ~= nil
		or vim.uv.fs_stat(path .. "/src/grammar.json") ~= nil
		or vim.uv.fs_stat(path .. "/grammar.js") ~= nil
end

local function validate_installed_parser(lang, parser_dir)
	local parser_path = parser_dir .. "/" .. lang .. ".so"
	if not vim.uv.fs_stat(parser_path) then
		return false, "parser library missing: " .. parser_path
	end

	local ok, err = pcall(vim.treesitter.query.get, lang, "highlights")
	if not ok then
		return false, "highlight query invalid: " .. tostring(err)
	end

	return true, nil
end

local function delete_file_if_exists(path)
	if vim.uv.fs_stat(path) then
		vim.uv.fs_unlink(path)
	end
end

local function ts_log_path()
	return vim.fn.stdpath("state") .. "/ts-install-local.log"
end

local function ts_event_path()
	return vim.fn.stdpath("state") .. "/ts-install-local.events"
end

local function ts_log(log_path, message)
	vim.fn.mkdir(vim.fs.dirname(log_path), "p")
	local fd = io.open(log_path, "a")
	if fd then
		fd:write(("[%s] %s\n"):format(os.date("%Y-%m-%d %H:%M:%S"), message))
		fd:close()
	end
end

local function ts_event(event_path, message)
	if not event_path or event_path == "" then
		return
	end

	vim.fn.mkdir(vim.fs.dirname(event_path), "p")
	local fd = io.open(event_path, "a")
	if fd then
		fd:write(message .. "\n")
		fd:close()
	end
end

local function start_ts_event_notifier(event_path)
	local offset = 0
	local closed = false
	local timer = assert(vim.uv.new_timer())

	local function flush_events()
		if closed then
			return
		end

		local fd = io.open(event_path, "r")
		if not fd then
			return
		end

		local content = fd:read("*a") or ""
		fd:close()
		if #content <= offset then
			return
		end

		local unread = content:sub(offset + 1)
		offset = #content
		for line in unread:gmatch("[^\r\n]+") do
			vim.notify(line, vim.log.levels.INFO, { title = "Tree-sitter" })
		end
	end

	timer:start(250, 500, vim.schedule_wrap(flush_events))

	return {
		stop = function()
			flush_events()
			closed = true
			timer:stop()
			timer:close()
		end,
	}
end

local function read_parser_manifest(archive_root)
	local manifest_path = archive_root .. "/manifest.json"
	local fd = io.open(manifest_path, "r")
	if not fd then
		error("tree-sitter archive manifest not found: " .. manifest_path .. "; run updated gsync")
	end

	local content = fd:read("*a")
	fd:close()

	local ok, manifest = pcall(vim.json.decode, content)
	if not ok or type(manifest) ~= "table" then
		error("tree-sitter archive manifest is invalid JSON: " .. manifest_path)
	end

	local archives = {}
	for repo, entry in pairs(manifest) do
		if type(entry) == "table" and type(entry.revision) == "string" and type(entry.archive) == "string" then
			archives[repo] = {
				revision = entry.revision,
				archive = entry.archive,
				archive_path = archive_root .. "/" .. entry.archive,
			}
		end
	end

	return archives
end

local function run_logged(log_path, cmd)
	ts_log(log_path, "$ " .. table.concat(cmd, " "))
	local result = vim.system(cmd, { text = true }):wait()
	if result.stdout and result.stdout ~= "" then
		ts_log(log_path, "stdout:\n" .. vim.trim(result.stdout))
	end
	if result.stderr and result.stderr ~= "" then
		ts_log(log_path, "stderr:\n" .. vim.trim(result.stderr))
	end
	if result.code ~= 0 then
		error(("command failed with exit code %d: %s"):format(result.code, table.concat(cmd, " ")))
	end
end

local function run_ts_install_local_worker(log_path)
	ts_log(log_path, "tree-sitter local install worker started")

	package.loaded["nvim-treesitter.parsers"] = nil
	local parsers = require("nvim-treesitter.parsers")
	local archive_root, stage_root, parser_registry = build_parser_registry(parsers)
	local archive_cache_root = parser_archive_cache_root()
	local treesitter = require("nvim-treesitter")
	local treesitter_config = require("nvim-treesitter.config")
	local parser_dir = treesitter_config.get_install_dir("parser")
	local parser_info_dir = treesitter_config.get_install_dir("parser-info")

	ts_log(log_path, "reading parser archive manifest from " .. archive_root)
	local source_archives = read_parser_manifest(archive_root)
	ts_log(log_path, ("found %d parser source archives"):format(vim.tbl_count(source_archives)))

	local configured, missing_repos = {}, {}
	local pending_languages = {}
	local pending_repos = {}
	local pending_repo_order = {}
	parser_overrides = {}

	for _, lang in ipairs(languages) do
		local detail = parser_registry[lang]
		if detail and source_archives[detail.repo] then
			local archive = source_archives[detail.repo]
			local expected_revision = archive.revision
			detail.revision = expected_revision
			detail.archive = archive.archive
			detail.archive_path = archive.archive_path
			configured[detail.repo] = true
			parser_overrides[lang] = {
				path = detail.staged_path,
				revision = expected_revision,
			}

			local installed_revision = read_trimmed_file(parser_info_dir .. "/" .. lang .. ".revision")
			local pending_reason = nil
			if installed_revision ~= expected_revision then
				pending_reason = ("revision mismatch: installed=%s expected=%s"):format(
					tostring(installed_revision),
					expected_revision
				)
			else
				local installed_ok, installed_reason = validate_installed_parser(lang, parser_dir)
				if not installed_ok then
					pending_reason = installed_reason
					detail.force_stage = true
				end
			end

			if pending_reason then
				ts_log(log_path, ("parser pending: %s: %s"):format(lang, pending_reason))
				table.insert(pending_languages, lang)
				if not pending_repos[detail.repo] then
					pending_repos[detail.repo] = detail
					table.insert(pending_repo_order, detail.repo)
				elseif detail.force_stage then
					pending_repos[detail.repo].force_stage = true
				end
			else
				ts_log(log_path, ("parser current: %s @ %s"):format(lang, expected_revision))
			end
		elseif detail then
			missing_repos[detail.repo] = true
		end
	end

	ts_log(log_path, ("configured %d parser repos"):format(vim.tbl_count(configured)))
	if next(missing_repos) ~= nil then
		ts_log(log_path, "missing parser repos: " .. table.concat(vim.tbl_keys(missing_repos), ", "))
	end

	if #pending_languages == 0 then
		ts_log(log_path, "all local parsers already installed and up to date")
		return
	end

	ts_log(
		log_path,
		("staging %d parser source archives from %s to %s"):format(#pending_repo_order, archive_root, stage_root)
	)
	local failed_repos = {}
	vim.fn.mkdir(archive_cache_root, "p")
	vim.fn.mkdir(stage_root, "p")
	for index, repo in ipairs(pending_repo_order) do
		local detail = pending_repos[repo]
		local staged_compile_path = parser_compile_path(detail, detail.staged_path)

		if not detail.archive_path or not vim.uv.fs_stat(detail.archive_path) then
			failed_repos[repo] = "source archive missing on fileshare: " .. tostring(detail.archive_path)
			ts_log(log_path, ("archive missing: %s (%d/%d): %s"):format(repo, index, #pending_repo_order, failed_repos[repo]))
			goto continue_stage
		end

		local staged_revision = read_trimmed_file(detail.staged_path .. "/.gsync-revision")
		if
			not detail.force_stage
			and detail.revision
			and staged_revision == detail.revision
			and parser_source_is_buildable(staged_compile_path)
		then
			ts_log(log_path, ("stage current: %s (%d/%d)"):format(repo, index, #pending_repo_order))
		else
			local local_archive = archive_cache_root .. "/" .. detail.archive
			if vim.uv.fs_stat(local_archive) then
				ts_log(log_path, ("archive cache current: %s (%d/%d)"):format(repo, index, #pending_repo_order))
			else
				local tmp_archive = local_archive .. ".tmp"
				delete_file_if_exists(tmp_archive)
				ts_log(log_path, ("copying archive %s (%d/%d)"):format(repo, index, #pending_repo_order))
				local copy_ok, copy_err = pcall(run_logged, log_path, {
					"cp",
					detail.archive_path,
					tmp_archive,
				})
				if not copy_ok then
					failed_repos[repo] = tostring(copy_err)
					ts_log(log_path, ("archive copy failed: %s (%d/%d): %s"):format(repo, index, #pending_repo_order, failed_repos[repo]))
					goto continue_stage
				end
				if vim.fn.rename(tmp_archive, local_archive) ~= 0 then
					failed_repos[repo] = "failed to move copied archive into cache: " .. local_archive
					ts_log(log_path, ("archive cache move failed: %s (%d/%d): %s"):format(repo, index, #pending_repo_order, failed_repos[repo]))
					goto continue_stage
				end
			end

			ts_log(log_path, ("extracting archive %s (%d/%d)"):format(repo, index, #pending_repo_order))
			vim.fn.delete(detail.staged_path, "rf")
			local ok, err = pcall(run_logged, log_path, {
				"tar",
				"-xzf",
				local_archive,
				"-C",
				stage_root,
			})
			if not ok then
				delete_file_if_exists(local_archive)
				failed_repos[repo] = tostring(err)
				ts_log(log_path, ("archive extract failed: %s (%d/%d): %s"):format(repo, index, #pending_repo_order, failed_repos[repo]))
				goto continue_stage
			end

			if not parser_source_is_buildable(staged_compile_path) then
				failed_repos[repo] = "staged repo is missing parser build inputs after copy: " .. staged_compile_path
				ts_log(log_path, ("stage invalid: %s (%d/%d): %s"):format(repo, index, #pending_repo_order, failed_repos[repo]))
			else
				vim.fn.writefile({ detail.revision }, detail.staged_path .. "/.gsync-revision")
			end
		end

		::continue_stage::
	end

	package.loaded["nvim-treesitter.parsers"] = nil
	require("nvim-treesitter.parsers")

	ts_log(log_path, ("installing/updating %d parsers"):format(#pending_languages))
	local failed_languages = {}
	for index, lang in ipairs(pending_languages) do
		local detail = parser_registry[lang]
		if detail and failed_repos[detail.repo] then
			local reason = failed_repos[detail.repo]
			ts_log(log_path, ("skipping %s (%d/%d): %s"):format(lang, index, #pending_languages, reason))
			table.insert(failed_languages, ("%s: %s"):format(lang, reason))
			goto continue_install
		end

		ts_log(log_path, ("installing %s (%d/%d)"):format(lang, index, #pending_languages))
		ts_event(vim.env.NVIM_TS_INSTALL_LOCAL_EVENTS, "installing " .. lang)
		local ok, success = treesitter.install({ lang }, { force = true, max_jobs = 1 }):pwait()
		if not ok or not success then
			local reason = ("failed to install %s: %s"):format(lang, tostring(success))
			ts_log(log_path, reason)
			table.insert(failed_languages, reason)
			goto continue_install
		end
		ts_log(log_path, ("installed %s"):format(lang))
		local valid, valid_reason = validate_installed_parser(lang, parser_dir)
		if not valid then
			local reason = ("installed parser validation failed for %s: %s"):format(lang, valid_reason)
			ts_log(log_path, reason)
			table.insert(failed_languages, reason)
			goto continue_install
		end
		ts_log(log_path, ("validated %s"):format(lang))
		ts_event(vim.env.NVIM_TS_INSTALL_LOCAL_EVENTS, "installed " .. lang)

		::continue_install::
	end

	if #failed_languages > 0 then
		ts_log(log_path, "tree-sitter local install completed with failures:\n- " .. table.concat(failed_languages, "\n- "))
		error(("tree-sitter local install completed with %d failure(s); see %s"):format(#failed_languages, log_path))
	end

	ts_log(log_path, "tree-sitter local install worker complete")
end

-- On the air-gapped box, parser source archives live on the fileshare.
-- Copy changed archives to local cache and extract locally so the slow share
-- only serves large sequential reads, not thousands of metadata operations.
if fileshare.is_airgapped() then
	-- nvim-treesitter.install() reloads this module before each install/update.
	-- Provide a custom loader so every reload re-applies the local repo paths.
	package.preload["nvim-treesitter.parsers"] = function()
		local parser_file = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/parsers.lua", false)[1]
		assert(parser_file, "nvim-treesitter parsers.lua not found in runtimepath")

		local loader = assert(loadfile(parser_file))
		local parsers = loader()
		apply_parser_overrides(parsers)
		return parsers
	end
end

vim.api.nvim_create_user_command("TSInstallLocal", function()
	if not fileshare.is_airgapped() then
		ts_status(
			"tree-sitter: fileshare not found at " .. fileshare.fileshare_root() .. "; mount it or set NVIM_FILESHARE_ROOT",
			vim.log.levels.ERROR
		)
		return
	end

	if ts_install_running then
		ts_status("tree-sitter: local install worker already running", vim.log.levels.WARN)
		return
	end
	ts_install_running = true

	local log_path = ts_log_path()
	local event_path = ts_event_path()
	vim.fn.mkdir(vim.fs.dirname(log_path), "p")
	vim.fn.writefile({
		("[%s] tree-sitter local install launcher started"):format(os.date("%Y-%m-%d %H:%M:%S")),
	}, log_path)
	vim.fn.writefile({}, event_path)

	ts_status("tree-sitter: starting local install worker; run :TSInstallLocalLog to view logs")
	local event_notifier = start_ts_event_notifier(event_path)
	local command = {
		"env",
		"NVIM_TS_INSTALL_LOCAL_LOG=" .. log_path,
		"NVIM_TS_INSTALL_LOCAL_EVENTS=" .. event_path,
		vim.v.progpath,
		"--headless",
		"+TSInstallLocalWorker",
		"+qa",
	}

	vim.system(command, { text = true }, function(result)
		vim.schedule(function()
			ts_install_running = false
			event_notifier.stop()
			if result.stdout and result.stdout ~= "" then
				ts_log(log_path, "worker stdout:\n" .. vim.trim(result.stdout))
			end
			if result.stderr and result.stderr ~= "" then
				ts_log(log_path, "worker stderr:\n" .. vim.trim(result.stderr))
			end
			if result.code == 0 then
				ts_status("tree-sitter: local install worker finished")
			else
				local failure = result.code and ("exit code %d"):format(result.code)
					or ("signal %s"):format(tostring(result.signal))
				ts_status(
					("tree-sitter: local install worker failed with %s; see %s"):format(failure, log_path),
					vim.log.levels.ERROR
				)
			end
		end)
	end)
end, {
	desc = "Install missing tree-sitter parsers from local archives in a background worker",
})

vim.api.nvim_create_user_command("TSInstallLocalWorker", function()
	local log_path = vim.env.NVIM_TS_INSTALL_LOCAL_LOG or ts_log_path()
	local ok, err = xpcall(function()
		run_ts_install_local_worker(log_path)
	end, debug.traceback)
	if not ok then
		ts_log(log_path, "worker failed:\n" .. tostring(err))
		error(err)
	end
end, {
	desc = "Internal tree-sitter local install worker",
})

vim.api.nvim_create_user_command("TSInstallLocalLog", function()
	vim.cmd.edit(ts_log_path())
end, {
	desc = "Open tree-sitter local install log",
})
