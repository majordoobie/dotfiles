vim.cmd("let g:netrw_liststyle = 3")

-- Trying to see if this fixes my env issues when using toggleterm
vim.opt.shell = "/bin/zsh"

-- line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
vim.opt.tabstop = 4 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 4 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
vim.opt.wrap = false -- disable line wrapping

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
vim.opt.cursorline = false -- highlight the current cursor line


-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
vim.opt.undodir = os.getenv("HOME") .. "/.undodir"
vim.opt.undofile = true
--vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
vim.opt.swapfile = false

-- enable spell check
vim.opt.spelllang = {"en_us"}
vim.opt.spell = true

-- This is the syntax highlighting for robot.txt files
vim.cmd [[
    let s:cpo_save=&cpo
    set cpo&vim

    " Try to guess when dealing with .html, .txt, or .rst files:
    au BufNewFile,BufRead *.txt call s:FTrobot()
    au BufNewFile,BufRead *.rst call s:FTrobot()
    au BufNewFile,BufRead *.html call s:FTrobot()
    " No resorting to heuristics for .robot files:
    au BufNewFile,BufRead *.robot setlocal filetype=robot

    func! s:FTrobot()
        let b:topl = getline(1)
        if (exists("g:robot_syntax_for_txt") && g:robot_syntax_for_txt)
        \ || b:topl =~ '\*\*\*.\{-}\*\*\*'
        \ || b:topl =~ '^# -\*- coding: robot -\*-$'
            setlocal filetype=robot
        endif
    endfunc

    "------------------------------------------------------------------------
    let &cpo=s:cpo_save
]]
