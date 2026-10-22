vim.opt.autoread      = true
vim.opt.backup        = false
vim.opt.clipboard     = "unnamedplus"
vim.opt.cmdheight     = 1
vim.opt.confirm       = true
vim.opt.hidden        = true
vim.opt.laststatus    = 2
vim.opt.mouse         = "a"
vim.opt.number        = true
vim.opt.showcmd       = true
vim.opt.swapfile      = false
vim.opt.termguicolors = true
vim.opt.timeoutlen    = 300
vim.opt.ttimeoutlen   = 0
vim.opt.wrap          = false
vim.opt.writebackup   = false
vim.opt.undofile      = true
vim.opt.signcolumn    = "yes"
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.opt.splitright    = true
vim.opt.splitbelow    = true
vim.opt.scrolloff     = 8
vim.opt.updatetime    = 250
vim.opt.cursorline    = true

vim.diagnostic.config({ virtual_text = true })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Folding via treesitter (za toggle, zc close, zo open, zM close all, zR open all)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel  = 99 -- start with everything open
vim.opt.foldtext   = "v:lua.FoldText()"
vim.opt.fillchars:append({ fold = " " })

function _G.FoldText()
  local line = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.bo.tabstop))
  return line .. "  ⋯ " .. (vim.v.foldend - vim.v.foldstart + 1) .. " lines"
end
