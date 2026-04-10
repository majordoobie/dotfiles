-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

-- Run :TSUpdate after install or update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	git_source("nvim-treesitter/nvim-treesitter"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- Neovim 0.12 handles highlight/indent natively via vim.treesitter
-- nvim-treesitter now only manages parser installation
require("nvim-treesitter").install({
	"arduino",
	"asm",
	"bash",
	"c",
	"cpp",
	"cmake",
	"csv",
	"diff",
	"disassembly",
	"dockerfile",
	"doxygen",
	"git_config",
	"git_rebase",
	"gitignore",
	"go",
	"html",
	"htmldjango",
	"http",
	"hjson",
	"java",
	"javascript",
	"json",
	"json5",
	"llvm",
	"lua",
	"luap",
	"make",
	"objdump",
	"python",
	"requirements",
	"regex",
	"rust",
	"sql",
	"tmux",
	"nix",
	"vim",
	"vimdoc",
	"toml",
	"yaml",
	"zig",
})
