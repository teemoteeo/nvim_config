return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
  config = function()
    -- Enable built-in treesitter highlighting on every FileType
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Install parsers once in background on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        require("nvim-treesitter").install({ "c", "cpp", "lua", "python", "bash", "vim", "vimdoc" })
      end,
    })
  end,
}
