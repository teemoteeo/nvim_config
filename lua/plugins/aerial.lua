return {
  {
    "stevearc/aerial.nvim",
    branch = vim.fn.has("nvim-0.12") == 0 and "nvim-0.11" or nil, -- 42 machines run nvim 0.11
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<M-m>", "<cmd>AerialToggle right<CR>", desc = "Toggle aerial outline" },
    },
    opts = {
      backends = { "treesitter", "lsp" },
      lsp = { diagnostics_trigger_update = false },
      attach_mode = "global",
      post_parse_symbol = function(_, item, _)
        if item.end_lnum and item.lnum and (item.kind == "Function" or item.kind == "Method") then
          item.name = string.format("%s (%d)", item.name, item.end_lnum - item.lnum + 1)
        end
        return true
      end,
      layout = {
        default_direction = "right",
        placement = "edge",
        min_width = 30,
      },
      show_guides = true,
    },
  },
}
