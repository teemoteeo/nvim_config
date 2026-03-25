-- Override vim-visual-multi's 'i' mapping in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("n", "i", "<cmd>startinsert<CR>", { buffer = true, desc = "Enter terminal mode" })
    vim.keymap.set("n", "a", "<cmd>startinsert<CR>", { buffer = true, desc = "Enter terminal mode" })
  end,
})

-- Auto-reload files changed externally (e.g. by Claude Code)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Auto-save when leaving a buffer
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.modified then
      vim.cmd("write")
    end
  end
})
