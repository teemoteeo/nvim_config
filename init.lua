vim.g.mapleader = " "
vim.cmd('source ~/stdheader.vim')
vim.cmd('source ~/gdb.vim')

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins")
