local g = vim.g
local o = vim.opt

g.mapleader = ','
g.localleader = ','

o.cursorline = true
o.number = true
o.laststatus = 3 -- full-width status line
o.backup = false
o.swapfile = false
o.splitbelow = true
o.splitright = true
o.mouse = 'r'

o.expandtab = true
o.tabstop = 2
o.shiftround = true
o.shiftwidth = 2

o.list = true
o.listchars = { tab = '>·', trail = '·' }
