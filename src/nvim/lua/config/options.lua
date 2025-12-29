-- scroll offset
vim.opt.scrolloff = 8
-- cursor style
  -- default:
  -- "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"
  -- according to https://neovim.io/doc/user/options.html#'guicursor', though
  -- the last part doesn't work
vim.opt.guicursor = "n-v-c-sm-i:block,ci-ve:ver25,r-cr-o:hor20"
-- line numbers
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
-- indentation
local indent_size = 2
vim.opt.tabstop = indent_size
vim.opt.softtabstop = indent_size
vim.opt.shiftwidth = indent_size
vim.opt.expandtab = true
vim.opt.smartindent = true
-- max line width
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"
-- copy to OS clipboard
vim.opt.clipboard = "unnamed"
-- mark trailing space
vim.opt.list = true
vim.opt.listchars = "trail:·,tab:→ "
-- always show tabline, even when there's only one tab
vim.opt.showtabline = 2
-- always show sign column to avoid shifting text when in use (e.g. by gitsigns)
vim.opt.signcolumn = "yes:1"
-- save per-file undo history to a file, allowing undo history to be restored
-- when reopening a file
vim.opt.undofile = true
-- ignore case when searching with / and ? unless an upper case character is
-- provided
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- use British English for spell checking (enabled by file type in an autocmd)
vim.opt.spelllang = "en_gb"
-- don't show the mode since lualine reports it (though only insert mode
-- seems to show it)
vim.opt.showmode = false
-- don't show location since lualine reports it
vim.opt.ruler = false
