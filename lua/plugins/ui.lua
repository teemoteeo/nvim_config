return {
  {
    "tomiis4/BufferTabs.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("buffertabs").setup({ vertical = "bottom" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local api = require("nvim-tree.api")

      -- Open file automatically after creation
      api.events.subscribe(api.events.Event.FileCreated, function(file)
        vim.schedule(function()
          vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
        end)
      end)

      -- Close buffer automatically after deletion
      api.events.subscribe(api.events.Event.FileRemoved, function(file)
        vim.schedule(function()
          local bufnr = vim.fn.bufnr(file.fname)
          if bufnr ~= -1 then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end)
      end)

      require("nvim-tree").setup({
        filters = { dotfiles = true },
        git = { ignore = false },
        update_focused_file = { enable = true },
        auto_reload_on_write = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        on_attach = function(bufnr)
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "<C-n>", api.fs.create, { buffer = bufnr, nowait = true, silent = true, desc = "Create file/folder" })
        end,
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  {
    "sontungexpt/stcursorword",
    event = "VeryLazy",
    config = function()
      require("stcursorword").setup({
        max_word_length = 100,
        min_word_length = 2,
        highlight = { underline = true },
      })
    end,
  },
  { "luxvim/nvim-luxterm" },
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",
    opts = {},
    keys = {
      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" } },
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" } },
      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
      { "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" } },
      { "<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" } },
    },
  },
}
