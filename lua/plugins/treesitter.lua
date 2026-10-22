return {
  "nvim-treesitter/nvim-treesitter",
  -- pinned: later commits require nvim 0.12 (vim.list.unique); unpin after upgrading nvim
  commit = "4d9916e477e5d4e3b245845dfd285edf429f3252",
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
