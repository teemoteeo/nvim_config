-- Override vim-visual-multi's 'i' mapping in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("n", "i", "<cmd>startinsert<CR>", { buffer = true, desc = "Enter terminal mode" })
    vim.keymap.set("n", "a", "<cmd>startinsert<CR>", { buffer = true, desc = "Enter terminal mode" })
  end,
})

-- Auto-reload files changed externally (e.g. by Claude Code)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then vim.cmd("checktime") end
  end,
})

vim.fn.timer_start(1000, function()
  if vim.fn.mode() ~= "c" then
    pcall(vim.cmd, "checktime")
  end
end, { ["repeat"] = -1 })

-- Auto-save when leaving a buffer (skip special/unnamed buffers)
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.bufname() ~= "" then
      vim.cmd("write")
    end
  end
})
