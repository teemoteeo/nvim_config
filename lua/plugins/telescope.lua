return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<M-o>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<M-g>", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
      {
        -- M-f is word jump on macOS (see keymaps.lua)
        vim.fn.has("mac") == 1 and "<M-F>" or "<M-f>",
        function()
          local state = require("telescope.state")
          local action_state = require("telescope.actions.state")
          require("telescope.builtin").current_buffer_fuzzy_find({
            default_text = vim.g._telescope_find_query or "",
            attach_mappings = function(prompt_bufnr)
              vim.api.nvim_create_autocmd("BufWinLeave", {
                buffer = prompt_bufnr,
                once = true,
                callback = function()
                  local picker = action_state.get_current_picker(prompt_bufnr)
                  if picker then
                    vim.g._telescope_find_query = picker:_get_prompt()
                  end
                end,
              })
              return true
            end,
          })
        end,
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
