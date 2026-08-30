vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- General
opt.number = true
opt.relativenumber = true

-- Clipboard
opt.clipboard:append("unnamedplus")

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- split windows
opt.splitright = true
opt.splitbelow = true

-- turn off swapfile
opt.swapfile = false

-- folds: keep everything open when a window/buffer is first shown
opt.foldlevel = 99
opt.foldlevelstart = 99
