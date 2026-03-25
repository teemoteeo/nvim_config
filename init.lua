vim.g.mapleader = " "

-- Load external scripts if they exist
local function safe_source(path)
  local expanded = vim.fn.expand(path)
  if vim.fn.filereadable(expanded) == 1 then
    vim.cmd('source ' .. expanded)
  end
end

local config_dir = vim.fn.stdpath("config")
safe_source(config_dir .. "/scripts/stdheader.vim")
safe_source(config_dir .. "/scripts/gdb.vim")

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins")
