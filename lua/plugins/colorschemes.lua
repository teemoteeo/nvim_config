return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        theme = "dragon",
        background = { dark = "wave", light = "lotus" },
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "gbprod/nord.nvim",
    lazy = true,
    config = function()
      require("nord").setup({
        transparent = true,
        terminal_colors = true,
        diff = { mode = "bg" },
        borders = true,
        errors = { mode = "bg" },
        search = { theme = "vim" },
        styles = {
          comments = { italic = true },
        },
      })
    end,
  },
  { "savq/melange-nvim", lazy = true },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        saturation = 1,
        italic_comments = false,
        terminal_colors = true,
      })
    end,
  },
}
