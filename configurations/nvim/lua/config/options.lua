-- General: {{{
vim.opt.spelllang = "en,de"
vim.opt.backspace = "indent,eol,start"
vim.opt.mouse = "a"
vim.opt.virtualedit = "onemore"
vim.opt.hidden = true
vim.opt.nrformats = "alpha,bin,hex"
vim.opt.autoread = true
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 50
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
if os.getenv("SHELL") then
  vim.opt.shell = os.getenv("SHELL")
else
  vim.opt.shell = "/bin/sh"
end
-- vim.opt.autocomplete = true
vim.o.pumborder = "rounded"
vim.o.pummaxwidth = 40
vim.o.completeopt = "menu,menuone,noselect"
-- }}}

-- Encoding: {{{
vim.opt.bomb = false
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,ISO-8859-1,latin1"
-- }}}

-- Formatting: {{{
vim.opt.list = true
vim.opt.listchars = "tab:»-,extends:›,precedes:‹,nbsp:·,trail:·"
vim.opt.wrap = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 8
vim.opt.joinspaces = false
vim.opt.formatoptions:append({ "o", "j" })
-- }}}

-- Splits: {{{
vim.opt.splitbelow = true
vim.opt.splitright = true -- Often used together
-- }}}

-- UI: {{{
vim.opt.title = true
vim.opt.showmatch = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5
vim.opt.sidescroll = 1
vim.opt.showbreak = "↪"
vim.opt.signcolumn = "number"
vim.opt.showtabline = 2
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.termguicolors = true
-- }}}

-- Backups: {{{
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
local undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
-- }}}

-- Search: {{{
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.wildignorecase = true
vim.opt.smartcase = true
-- }}}

-- Diff: {{{
vim.opt.diffopt:append({
  "internal",
  "algorithm:histogram",
  "indent-heuristic",
  "filler",
  "vertical",
  "context:5",
  "foldcolumn:1",
})
-- }}}

-- Folding settings {{{
vim.opt.smoothscroll = false
vim.wo.foldmethod = "manual"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
-- }}}

-- vim: set sw=4 ts=8 sts=4 et tw=78 foldenable foldmethod=marker spell:
