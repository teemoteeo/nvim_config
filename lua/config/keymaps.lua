vim.keymap.set("n", ";", ":", { desc = "Quick command mode" })
-- Terminal mode: hide terminal with Alt+D
vim.keymap.set("t", "<A-d>", "<C-\\><C-n><cmd>ToggleTerm<CR>", { desc = "Hide terminal" })
vim.keymap.set("n", "<A-v>", "<C-w>W", { desc = "Previous window" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Quick escape" })
vim.keymap.set("i", "<Space>", "<Space>", { noremap = true, desc = "Insert space immediately" })
vim.keymap.set("n", "<A-n>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<A-p>", ":bprev<CR>", { desc = "Previous buffer" })

-- Cycle through windows with Alt+A
vim.keymap.set("n", "<A-a>", "<C-W>w", { desc = "Next window" })
vim.keymap.set("t", "<A-a>", "<C-\\><C-n><C-W>w", { desc = "Next window (from terminal)" })

-- Close buffer with Alt+W (switch to previous buffer first, then delete)
vim.keymap.set("n", "<A-w>", ":bp|bd #<CR>", { nowait = true, desc = "Close buffer" })

-- Move selected block up/down
local function move_block(direction)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  if direction == "up" then
    vim.cmd(start_line .. "," .. end_line .. "m " .. (start_line - 2))
  else
    vim.cmd(start_line .. "," .. end_line .. "m " .. (end_line + 1))
  end
  vim.cmd("normal! gv")
end

vim.keymap.set("v", "<M-k>", function() move_block("up") end, { silent = true, desc = "Move block up" })
vim.keymap.set("v", "<M-j>", function() move_block("down") end, { silent = true, desc = "Move block down" })

-- Auto-pairs
vim.keymap.set("i", "$6", "()<Left>", { desc = "Insert parentheses" })
vim.keymap.set("i", "$2", "#include \"\"<Left>", { desc = "Insert #include" })
vim.keymap.set("i", "$3", "[]<Left>", { desc = "Insert brackets" })
vim.keymap.set("i", "$4", "{}<Left>", { desc = "Insert braces" })
vim.keymap.set("i", "$1", "{<CR>}<Esc>O", { desc = "Insert block braces" })
vim.keymap.set("i", "$q", "''<Left>", { desc = "Insert single quotes" })
vim.keymap.set("i", "$e", '""<Left>', { desc = "Insert double quotes" })

-- F1: Save file
vim.keymap.set("n", "<F1>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<F1>", "<Esc>:w<CR>", { desc = "Save file" })

-- F2: Insert header (42 header for C, shebang for Python)
function InsertHeader()
  local ft = vim.bo.filetype
  if ft == "c" or ft == "cpp" or vim.fn.expand("%:e") == "h" then
    vim.cmd("Stdheader")
  elseif ft == "python" then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/env python3" })
  end
end

vim.keymap.set("n", "<F2>", InsertHeader, { desc = "Insert file header" })
vim.keymap.set("i", "<F2>", "<Esc>:lua InsertHeader()<CR>", { desc = "Insert file header" })

-- F5: Compile & Run
function CompileRun()
  if vim.bo.buftype ~= "" then
    return
  end
  vim.cmd("write")
  local ft = vim.bo.filetype
  if ft == "c" then
    vim.cmd("!gcc % -o a.out && valgrind --leak-check=full -s ./a.out")
  elseif ft == "cpp" then
    vim.cmd("!g++ % -o %< && time ./%<")
  elseif ft == "java" then
    vim.cmd("!javac % && time java %")
  elseif ft == "sh" then
    vim.cmd("!time bash %")
  elseif ft == "python" then
    vim.cmd("!echo && echo && time python3 %")
  elseif ft == "go" then
    vim.cmd("!go build %< && time go run %")
  elseif ft == "matlab" then
    vim.cmd("!time octave %")
  end
end

vim.keymap.set("n", "<F5>", CompileRun, { desc = "Compile and run" })
vim.keymap.set("i", "<F5>", "<Esc>:lua CompileRun()<CR>", { desc = "Compile and run" })
vim.keymap.set("v", "<F5>", "<Esc>:lua CompileRun()<CR>", { desc = "Compile and run" })

-- F6: Linter (filetype-aware)
function normcheck()
  if vim.bo.buftype ~= "" then
    return
  end
  vim.cmd("write")
  local ft = vim.bo.filetype
  if ft == "c" or ft == "cpp" then
    vim.cmd("!norminette %")
  elseif ft == "python" then
    vim.cmd("!flake8 %")
  end
end

vim.keymap.set("n", "<F6>", normcheck, { desc = "Run norminette" })
vim.keymap.set("i", "<F6>", "<Esc>:lua normcheck()<CR>", { desc = "Run norminette" })

-- F7: Write + Make (in terminal)
function wmake()
  if vim.bo.buftype ~= "" then
    return
  end
  vim.cmd("write")
  vim.cmd("TermExec cmd='make && make clean'")
end

vim.keymap.set("n", "<F7>", wmake, { desc = "Write, make, and run" })
vim.keymap.set("i", "<F7>", "<Esc>:lua wmake()<CR>", { desc = "Write, make, and run" })

vim.cmd("command Tree NvimTreeToggle")
vim.keymap.set("n", "<M-e>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

vim.keymap.set("n", "<M-t>", function()
  local dir = vim.fn.getcwd()
  local terms = require("toggleterm.terminal")
  local term = terms.get(1, true)
  local function enter_terminal_mode()
    vim.schedule(function()
      vim.cmd("startinsert")
    end)
  end

  if term then
    term.dir = dir
    if term.job_id then
      term:change_dir(dir)
    end
    term:toggle()
    enter_terminal_mode()
    return
  end

  term = terms.Terminal:new({ id = 1, dir = dir, direction = "float" })
  term:toggle()
  enter_terminal_mode()
end, { desc = "Toggle terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Persistent Claude terminal
local _claude_buf = nil
local _claude_win = nil

function ToggleClaude()
  -- If window is visible, just hide it
  if _claude_win and vim.api.nvim_win_is_valid(_claude_win) then
    vim.api.nvim_win_close(_claude_win, false)
    _claude_win = nil
    return
  end

  -- If buffer doesn't exist yet or process exited, create a new one
  if not _claude_buf or not vim.api.nvim_buf_is_valid(_claude_buf) then
    -- Create a fresh unlisted buffer first, then open the split
    _claude_buf = vim.api.nvim_create_buf(false, true)
    vim.cmd("vsplit")
    _claude_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(_claude_win, _claude_buf)
    vim.fn.termopen("claude", {
      on_exit = function()
        _claude_buf = nil
        _claude_win = nil
      end,
    })
    _claude_buf = vim.api.nvim_get_current_buf()
    -- Let Esc pass through to Claude instead of exiting terminal mode
    vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = _claude_buf, desc = "Pass Esc to Claude" })
  else
    -- Buffer alive, just show it in a new split
    vim.cmd("vsplit")
    _claude_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(_claude_win, _claude_buf)
  end

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<M-c>", ToggleClaude, { desc = "Toggle Claude terminal" })
vim.keymap.set("t", "<M-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  vim.schedule(ToggleClaude)
end, { desc = "Toggle Claude terminal (from terminal mode)" })
