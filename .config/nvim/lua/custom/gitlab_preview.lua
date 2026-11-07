-- Render the current markdown buffer through GitLab's own API so the preview
-- matches the instance exactly — GitLab Flavored Markdown, diagrams, [[_TOC_]],
-- and project-scoped references (#123, !456, ~label, @user) all resolve.
--
-- Requires two environment variables (keep the token in a gitignored file):
--   GITLAB_URL    e.g. https://gitlab.example.com
--   GITLAB_TOKEN  personal access token, scope: read_api
--
-- No plugin dependency — just curl, so it works on air-gapped systems where the
-- instance is reachable but the internet is not.

local M = {}

local function err(msg)
	vim.notify("GitLab preview: " .. msg, vim.log.levels.ERROR)
end

-- Turn a git remote URL into a GitLab project path ("group/subgroup/project").
-- Handles ssh (git@host:group/proj.git), ssh:// and https:// forms.
function M.project_path(remote)
	if not remote or remote == "" then
		return nil
	end
	local path = remote:match("^[%w%+%-%.]+://[^/]+/(.+)$") -- scheme://host/path
		or remote:match("^[^@]+@[^:]+:(.+)$") -- git@host:path
	if not path then
		return nil
	end
	return (path:gsub("%.git$", ""):gsub("^/+", ""):gsub("/+$", ""))
end

local function current_project()
	local remote = vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait()
	if remote.code ~= 0 then
		return nil
	end
	return M.project_path(vim.trim(remote.stdout))
end

-- Minimal GitLab-ish styling. The API returns a bare HTML fragment without
-- GitLab's stylesheet, so structure is exact but the look is an approximation.
local function wrap_html(body, title)
	return table.concat({
		"<!doctype html><html><head><meta charset='utf-8'>",
		"<title>" .. title .. "</title><style>",
		":root{color-scheme:light dark}",
		"body{margin:0;padding:2rem 1rem;font:16px/1.6 -apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:#fff;color:#303030}",
		"main{max-width:900px;margin:0 auto}",
		"h1,h2{border-bottom:1px solid #dbdbdb;padding-bottom:.3em}",
		"h1,h2,h3,h4,h5,h6{margin:1.5em 0 .6em;line-height:1.3}",
		"code{background:#f0f0f0;padding:.2em .4em;border-radius:3px;font-size:.9em}",
		"pre{background:#f0f0f0;padding:1rem;border-radius:4px;overflow-x:auto}",
		"pre code{background:none;padding:0}",
		"blockquote{margin:1em 0;padding:.5em 1em;border-left:3px solid #dbdbdb;color:#666}",
		"table{border-collapse:collapse;margin:1em 0;display:block;overflow-x:auto}",
		"th,td{border:1px solid #dbdbdb;padding:.5em .75em}",
		"th{background:#fafafa}",
		"img{max-width:100%}",
		"a{color:#1068bf;text-decoration:none}a:hover{text-decoration:underline}",
		"@media(prefers-color-scheme:dark){",
		"body{background:#1f1e24;color:#ececef}",
		"h1,h2{border-color:#434248}",
		"code,pre{background:#2b2a2f}",
		"blockquote{border-color:#434248;color:#a4a3a8}",
		"th,td{border-color:#434248}th{background:#2b2a2f}",
		"a{color:#63a6e9}}",
		"</style></head><body><main>",
		body,
		"</main></body></html>",
	}, "\n")
end

local function opener()
	if vim.fn.has("mac") == 1 then
		return { "open" }
	elseif vim.fn.has("wsl") == 1 then
		return vim.fn.executable("wslview") == 1 and { "wslview" } or { "explorer.exe" }
	end
	return { "xdg-open" }
end

function M.preview()
	local url, token = vim.env.GITLAB_URL, vim.env.GITLAB_TOKEN
	if not url or url == "" then
		return err("GITLAB_URL is not set")
	end
	if not token or token == "" then
		return err("GITLAB_TOKEN is not set (needs read_api scope)")
	end

	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	if vim.trim(text) == "" then
		return err("buffer is empty")
	end

	local payload = { text = text, gfm = true }
	local project = current_project()
	if project then
		payload.project = project
	end

	vim.notify("GitLab preview: rendering" .. (project and (" as " .. project) or "") .. "...")

	vim.system({
		"curl",
		"--silent",
		"--show-error",
		"--fail-with-body",
		"--max-time",
		"20",
		"--request",
		"POST",
		"--header",
		"PRIVATE-TOKEN: " .. token,
		"--header",
		"Content-Type: application/json",
		"--data",
		"@-",
		"--url",
		url:gsub("/+$", "") .. "/api/v4/markdown",
	}, { stdin = vim.json.encode(payload), text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				return err("request failed: " .. vim.trim(res.stderr ~= "" and res.stderr or res.stdout))
			end
			local ok, decoded = pcall(vim.json.decode, res.stdout)
			if not ok or type(decoded) ~= "table" or not decoded.html then
				return err("unexpected response: " .. vim.trim(res.stdout):sub(1, 200))
			end

			local name = vim.fn.expand("%:t")
			local out = vim.fn.tempname() .. ".html"
			vim.fn.writefile(vim.split(wrap_html(decoded.html, name ~= "" and name or "preview"), "\n"), out)

			local cmd = opener()
			table.insert(cmd, out)
			vim.system(cmd, {}, function(open_res)
				if open_res.code ~= 0 then
					vim.schedule(function()
						vim.notify("GitLab preview written to " .. out, vim.log.levels.WARN)
					end)
				end
			end)
		end)
	end)
end

return M
