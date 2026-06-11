return {
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<M-m>", "<cmd>AerialToggle right<CR>", desc = "Toggle aerial outline" },
    },
    opts = {
      backends = { "treesitter", "lsp" },
      lsp = { diagnostics_trigger_update = false },
      attach_mode = "global",
      layout = {
        default_direction = "right",
        placement = "edge",
        min_width = 30,
      },
      show_guides = true,
    },
  },
}
