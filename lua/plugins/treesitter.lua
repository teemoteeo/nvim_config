return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if ok then
      configs.setup({
        ensure_installed = { "c", "cpp", "lua", "python", "bash", "vim", "vimdoc" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    else
      -- Fallback for newer nvim-treesitter versions
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "cpp", "lua", "python", "bash", "vim", "vimdoc" },
        auto_install = true,
      })
    end
  end,
}
