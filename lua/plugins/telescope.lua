return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      {
        "<M-f>",
        function() require("telescope.builtin").current_buffer_fuzzy_find() end,
        desc = "Find in file",
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
        },
      })
    end,
  },
}
