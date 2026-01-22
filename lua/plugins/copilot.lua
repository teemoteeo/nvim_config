return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        window = {
          layout = "vertical",
          width = 0.4,
        },
      })
    end,
    keys = {
      { "<leader>cc", ":CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
      { "<leader>ce", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain code" },
      { "<leader>cf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix code" },
      { "<leader>co", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code" },
      { "<leader>ct", ":CopilotChatTests<CR>", mode = "v", desc = "Generate tests" },
      { "<leader>cq", ":CopilotChatReset<CR>", desc = "Reset chat" },
    },
  },
}
