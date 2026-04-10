-- Run with :luafile ~/.config/nvim/lua/packs/debug_binary_check.lua
-- or :lua dofile(vim.fn.stdpath("config") .. "/lua/packs/debug_binary_check.lua")

local function check(label, result)
	local status = result and "OK" or "FAIL"
	print(string.format("  [%s] %s", status, label))
	return result
end

local function check_val(label, value)
	print(string.format("  [--] %s: %s", label, tostring(value)))
	return value
end

print("\n=== blink.cmp binary check ===")
local blink_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
check_val("blink plugin path", blink_path)
check("blink plugin dir exists", vim.fn.isdirectory(blink_path) == 1)

local dylib = vim.fn.glob(blink_path .. "/target/release/*.dylib")
local so = vim.fn.glob(blink_path .. "/target/release/*.so")
check_val("local .dylib", dylib ~= "" and dylib or "(none)")
check_val("local .so", so ~= "" and so or "(none)")
check("has local binary", dylib ~= "" or so ~= "")

local fileshare = "/mnt/software/Neovim"
check("fileshare dir exists", vim.fn.isdirectory(fileshare) == 1)
check("blink.cmp subdir exists", vim.fn.isdirectory(fileshare .. "/blink.cmp") == 1)

local fileshare_binary = vim.fn.glob(fileshare .. "/blink.cmp/blink.cmp_*.so")
check_val("fileshare glob result", fileshare_binary ~= "" and fileshare_binary or "(none)")
check("fileshare binary found", fileshare_binary ~= "")

check("cargo available", vim.fn.executable("cargo") == 1)

print("\n=== codediff binary check ===")
local codediff_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/codediff.nvim"
check_val("codediff plugin path", codediff_path)
check("codediff plugin dir exists", vim.fn.isdirectory(codediff_path) == 1)

local lib_ext = vim.fn.has("mac") == 1 and "dylib" or "so"
local codediff_binary = vim.fn.glob(codediff_path .. "/libvscode_diff*." .. lib_ext)
check_val("local binary", codediff_binary ~= "" and codediff_binary or "(none)")
check("has local binary", codediff_binary ~= "")

check("codediff subdir exists", vim.fn.isdirectory(fileshare .. "/codediff.nvim") == 1)
local codediff_fileshare = vim.fn.glob(fileshare .. "/codediff.nvim/codediff.nvim-libvscode_*.so")
check_val("fileshare glob result", codediff_fileshare ~= "" and codediff_fileshare or "(none)")
check("fileshare binary found", codediff_fileshare ~= "")

if codediff_fileshare ~= "" then
	local ver = codediff_fileshare:match("_v(%d+%.%d+%.%d+)%.so$")
	check_val("extracted version", ver or "(failed to extract)")
end

print("\n=== packpath check ===")
check_val("packpath", vim.o.packpath)
check("site in packpath", vim.o.packpath:find("site") ~= nil)
check_val("stdpath('data')", vim.fn.stdpath("data"))
print()
