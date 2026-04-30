-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

local fileshare = require("config.fileshare")

local blink_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
local is_airgapped = fileshare.is_airgapped()

-- Blink.cmp ships its Rust fuzzy binary per-tag on the fileshare
-- (blink.cmp_v1.10.2.so, …). The ABI is tied to the plugin version so the tag match
-- must be exact; a newer ABI-incompatible binary would crash at require-time.
local function copy_from_fileshare()
	return fileshare.copy_tag_matched_binary({
		name = "blink.cmp",
		plugin_path = blink_path,
		subdir = "blink.cmp",
		source_tmpl = "blink.cmp_%s.so",
		dest = function(_)
			return blink_path .. "/target/release/libblink_cmp_fuzzy.so"
		end,
		post = function(_, path)
			-- Remove the `version` file so blink.cmp treats this as a manually placed binary
			-- (if present with a SHA, blink.cmp assumes it was built locally and skips the download path).
			local version_file = path .. "/target/release/version"
			if vim.uv.fs_stat(version_file) then
				os.remove(version_file)
			end
		end,
	})
end

-- On air-gapped: re-copy the binary from the fileshare whenever vim.pack installs or updates blink.cmp.
-- On internet: no hook needed — blink.cmp downloads its own binary on setup.
if is_airgapped then
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			if ev.data.spec.name == "blink.cmp" and (ev.data.kind == "install" or ev.data.kind == "update") then
				copy_from_fileshare()
			end
		end,
	})
end

vim.pack.add({
	git_source("folke/lazydev.nvim"),
	{ src = git_source("saghen/blink.cmp"), version = vim.version.range("1") },
	git_source("rafamadriz/friendly-snippets"),
}, { load = true })

-- Ensure a usable binary is in place before blink.cmp.setup() runs.
local has_binary = vim.fn.glob(blink_path .. "/target/release/*.so") ~= ""
	or vim.fn.glob(blink_path .. "/target/release/*.dylib") ~= ""

if not has_binary then
	if is_airgapped then
		copy_from_fileshare()
	else
		-- Internet-connected: clean up stale state from any prior partial build. If a `version` file
		-- exists without an accompanying binary, blink.cmp's download logic (fuzzy/download/init.lua)
		-- sees the SHA, assumes a local build exists, and refuses to download — removing the file lets
		-- the prebuilt-binary download from GitHub releases proceed normally.
		local version_file = blink_path .. "/target/release/version"
		if vim.uv.fs_stat(version_file) then
			os.remove(version_file)
		end
	end
end

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
	fuzzy = {
		-- Prefer the Rust binary; silently fall back to Lua if it fails to load
		implementation = "prefer_rust",
		-- On internet-connected machines: auto-download from GitHub releases
		-- On air-gapped machines: binary was copied from the fileshare above, no download needed
		prebuilt_binaries = { download = not is_airgapped },
	},

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
