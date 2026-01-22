local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  require("plugins.colorschemes"),
  require("plugins.lualine"),
  require("plugins.treesitter"),
  require("plugins.cmp"),
  require("plugins.ui"),
  require("plugins.copilot"),
})
