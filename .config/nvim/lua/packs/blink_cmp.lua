-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

-- Build blink.cmp Rust binary after install or update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "blink.cmp" and (ev.data.kind == "install" or ev.data.kind == "update") then
			vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
		end
	end,
})

-- Ensure blink.cmp Rust binary exists, fallback chain:
-- 1. Check fileshare for prebuilt binary (air-gapped network)
-- 2. Build from source with cargo
-- 3. Fall back to Lua fuzzy matcher
local blink_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
local has_binary = vim.fn.glob(blink_path .. "/target/release/*.dylib") ~= ""
	or vim.fn.glob(blink_path .. "/target/release/*.so") ~= ""
local use_lua_fuzzy = false
local fileshare_path = "/mnt/software/Neovim"

if vim.fn.isdirectory(blink_path) == 1 and not has_binary then
	-- Step 1: Try to copy prebuilt binary from fileshare
	-- Glob for any blink.cmp .so on the fileshare (version-agnostic)
	local fileshare_binary = vim.fn.glob(fileshare_path .. "/blink.cmp/blink.cmp_*.so")
	if fileshare_binary ~= "" then
		vim.fn.mkdir(blink_path .. "/target/release", "p")
		local dest = blink_path .. "/target/release/libblink_cmp_fuzzy.so"
		vim.api.nvim_echo(
			{ { "Copying blink.cmp binary from fileshare (may be slow)...", "WarningMsg" } },
			true,
			{}
		)
		vim.cmd("redraw")
		vim.uv.fs_copyfile(fileshare_binary, dest)
		-- Remove version file so blink doesn't try to re-download
		local version_file = blink_path .. "/target/release/version"
		if vim.uv.fs_stat(version_file) then
			os.remove(version_file)
		end
		vim.api.nvim_echo({ { "blink.cmp binary copied from fileshare!", "Normal" } }, true, {})
	-- Step 2: Try building from source with cargo
	elseif vim.fn.executable("cargo") == 1 then
		vim.api.nvim_echo({ { "🔨 Building blink.cmp Rust binary... (this may take a moment)", "WarningMsg" } }, true, {})
		local result = vim.system({ "cargo", "build", "--release" }, { cwd = blink_path }):wait()
		if result.code == 0 then
			vim.api.nvim_echo({ { "✅ blink.cmp build complete!", "Normal" } }, true, {})
		else
			vim.api.nvim_echo({ { "⚠️  blink.cmp build failed, falling back to Lua fuzzy matcher", "WarningMsg" } }, true, {})
			use_lua_fuzzy = true
		end
	-- Step 3: Fall back to Lua
	else
		vim.api.nvim_echo({ { "⚠️  No binary found, using Lua fuzzy matcher for blink.cmp", "WarningMsg" } }, true, {})
		use_lua_fuzzy = true
	end
end

vim.pack.add({
	git_source("folke/lazydev.nvim"),
	{ src = git_source("saghen/blink.cmp"), version = vim.version.range("1.0") },
	git_source("rafamadriz/friendly-snippets"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Proper completion for lua so that it can understand
-- neovim lua configs
-- ]]
require("lazydev").setup({
	library = {
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

-- [[
-- Replaces nvim-cmp + LuaSnip engine for a compiled completion engine
-- with all the sources included.
--
-- To accept: ctrl + y
-- ]]
require("blink.cmp").setup({
	fuzzy = use_lua_fuzzy
		and { implementation = "lua", prebuilt_binaries = { download = false } }
		or { prebuilt_binaries = { download = false } },

	keymap = {
		preset = "default",
		["<C-enter>"] = { "accept", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
	},

	appearance = {
		-- Sets the fallback highlight groups to nvim-cmp's highlight groups
		-- Useful for when your theme doesn't support blink.cmp
		-- Will be removed in a future release
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	sources = {
		-- add lazydev to your completion providers
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	cmdline = {
		sources = function()
			local type = vim.fn.getcmdtype()
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			if type == ":" then
				return { "cmdline" }
			end
			return {}
		end,
		completion = { ghost_text = { enabled = false } },
	},
	-- Displays the signature while adding the parameters of the function
	-- you are working on.
	signature = {
		enabled = true,
		window = {
			scrollbar = true,
			border = "rounded",
		},
	},
	completion = {
		-- Enable blink.cmp's built-in auto-brackets (works alongside nvim-autopairs)
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},

		-- As you scroll through the selection it will show docs for the selection
		-- to the right of the selection window
		documentation = { auto_show = true, auto_show_delay_ms = 100, window = { border = "rounded" } },

		-- allows to visually see what is going to be filled in
		ghost_text = { enabled = false },

		menu = {
			border = "rounded",
			draw = {
				align_to = "label",
				columns = {
					{ "kind_icon" },
					{ "label" },
					{ "label_description" },
					{ "source_name" },
				},
				components = {
					source_name = {
						width = { max = 30 },
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
						highlight = "BlinkCmpSource",
					},
				},
			},
		},
	},
})
