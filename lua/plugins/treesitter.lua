return {
  "nvim-treesitter/nvim-treesitter",
  -- pinned on nvim < 0.12 (42 machines): later commits need vim.list.unique
  commit = vim.fn.has("nvim-0.12") == 0 and "4d9916e477e5d4e3b245845dfd285edf429f3252" or nil,
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
