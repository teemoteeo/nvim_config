vim.keymap.set("n", ";", ":", { desc = "Quick command mode" })
-- Terminal mode: hide terminal with Alt+D
-- Alt+V: Toggle Python venv activation in terminal 1
local _venv_active = false

local function find_venv_activate()
  local cwd = vim.fn.getcwd()
  for _, name in ipairs({ ".venv", "venv", "env" }) do
    local path = cwd .. "/" .. name .. "/bin/activate"
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

local function toggle_venv()
  local terms = require("toggleterm.terminal")
  local term = terms.get(1, true)
  if not term or not term.job_id then
    vim.notify("Open a terminal first (Alt+T)", vim.log.levels.WARN)
    return
  end
  if _venv_active then
    vim.fn.jobsend(term.job_id, "deactivate\n")
    _venv_active = false
    vim.notify("Venv deactivated", vim.log.levels.INFO)
  else
    local activate = find_venv_activate()
    if not activate then
      vim.notify("No venv found (.venv / venv / env)", vim.log.levels.WARN)
      return
    end
    vim.fn.jobsend(term.job_id, "source " .. activate .. "\n")
    _venv_active = true
    vim.notify("Venv activated", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<M-v>", toggle_venv, { desc = "Toggle venv" })
vim.keymap.set("t", "<M-v>", toggle_venv, { desc = "Toggle venv (terminal)" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Quick escape" })
vim.keymap.set("i", "<Space>", "<Space>", { noremap = true, desc = "Insert space immediately" })
vim.keymap.set("n", "<A-n>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<A-p>", ":bprev<CR>", { desc = "Previous buffer" })

-- Cycle through windows with Alt+A
vim.keymap.set("n", "<A-a>", "<C-W>w", { desc = "Next window" })
vim.keymap.set("t", "<A-a>", "<C-\\><C-n><C-W>w", { desc = "Next window (from terminal)" })

-- Close buffer with Alt+W; if last buffer, open NvimTree instead of leaving empty screen
vim.keymap.set("n", "<A-w>", function()
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed <= 1 then
    vim.cmd("bd")
    vim.cmd("NvimTreeOpen")
  else
    vim.cmd("bp|bd #")
  end
end, { nowait = true, desc = "Close buffer" })

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

-- Alt+S: Save file
vim.keymap.set("n", "<M-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<M-s>", "<Esc>:w<CR>", { desc = "Save file" })

-- F2: Insert header (42 header for C, shebang for Python)
function InsertHeader()
  local ft = vim.bo.filetype
  if ft == "c" or ft == "cpp" or vim.fn.expand("%:e") == "h" then
    vim.cmd("Stdheader")
  elseif ft == "python" then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/env python3" })
  end
end

vim.keymap.set("n", "<M-h>", InsertHeader, { desc = "Insert file header" })
vim.keymap.set("i", "<M-h>", "<Esc>:lua InsertHeader()<CR>", { desc = "Insert file header" })

-- Alt+R: Smart compile & run
function CompileRun()
  if vim.bo.buftype ~= "" then
    return
  end
  vim.cmd("write")
  local ft = vim.bo.filetype
  local has_makefile = vim.fn.filereadable("Makefile") == 1
  if ft == "c" then
    if has_makefile then
      vim.cmd("TermExec cmd='make'")
    else
      local file = vim.fn.expand("%")
      vim.cmd("TermExec cmd='cc -Wall -Werror -Wextra " .. file .. " -o a.out && ./a.out'")
    end
  elseif ft == "python" then
    if has_makefile then
      vim.cmd("TermExec cmd='make run'")
    else
      local file = vim.fn.expand("%")
      vim.cmd("TermExec cmd='python3 " .. file .. "'")
    end
  end
end

vim.keymap.set("n", "<M-r>", CompileRun, { desc = "Compile and run" })
vim.keymap.set("i", "<M-r>", "<Esc>:lua CompileRun()<CR>", { desc = "Compile and run" })
vim.keymap.set("v", "<M-r>", "<Esc>:lua CompileRun()<CR>", { desc = "Compile and run" })
vim.keymap.set("t", "<M-r>", function()
  local terms = require("toggleterm.terminal")
  local term = terms.get(1, true)
  if not term or not term.job_id then return end
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/Makefile") ~= 1 then
    vim.notify("No Makefile found", vim.log.levels.WARN)
    return
  end
  local cmd = vim.fn.glob(cwd .. "/*.py") ~= "" and "make run\n" or "make\n"
  vim.fn.jobsend(term.job_id, cmd)
end, { desc = "Compile and run (terminal)" })

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

local function toggle_terminal()
  local dir = vim.fn.getcwd()
  local terms = require("toggleterm.terminal")
  local term = terms.get(1, true)
  if term then
    term.dir = dir
    if term.job_id then term:change_dir(dir) end
    term:toggle()
  else
    term = terms.Terminal:new({ id = 1, dir = dir, direction = "float" })
    term:toggle()
  end
  vim.schedule(function() vim.cmd("startinsert") end)
end

vim.keymap.set("n", "<M-t>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("i", "<M-t>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("v", "<M-t>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("t", "<M-t>", toggle_terminal, { desc = "Toggle terminal" })
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

vim.api.nvim_create_user_command("Cheatsheet", function()
  local sections = {
    { "Movement", {
      { "h j k l",       "left / down / up / right" },
      { "w / b",         "next / prev word" },
      { "e",             "end of word" },
      { "0 / ^ / $",     "line start / first char / end" },
      { "gg / G",        "file top / bottom" },
      { "Ctrl+d / Ctrl+u", "half page down / up" },
      { "{ / }",         "prev / next paragraph" },
      { "%",             "jump to matching bracket" },
      { "M-Right / M-Left", "word forward / backward" },
    }},
    { "Editing", {
      { "u / Ctrl+r",    "undo / redo" },
      { "dd / yy / p",   "delete / yank / paste line" },
      { "ciw / diw",     "change / delete inner word" },
      { "< > (visual)",  "indent left / right" },
      { "M-j / M-k",     "move block down / up" },
    }},
    { "Buffers & Windows", {
      { "M-n / M-p",     "next / prev buffer" },
      { "M-w",           "close buffer" },
      { "M-a",           "next window" },
      { "M-v",           "toggle venv" },
      { "M-z",           "toggle fullscreen" },
    }},
    { "Tools", {
      { "M-e",           "file explorer" },
      { "M-t",           "toggle terminal (all modes)" },
      { "M-v",           "toggle venv" },
      { "M-c",           "Claude terminal" },
      { "M-f",           "find in buffer" },
      { ";",             "command mode" },
      { "jj (insert)",   "escape" },
    }},
    { "File Actions", {
      { "M-s",           "save" },
      { "M-h",           "insert header" },
      { "M-r",           "compile & run (smart)" },
      { "F6",            "lint (norminette/flake8)" },
      { "F7",            "make" },
    }},
  }

  local lines = { "  Cheatsheet", "  " .. string.rep("─", 44), "" }
  for _, section in ipairs(sections) do
    table.insert(lines, "  [" .. section[1] .. "]")
    for _, entry in ipairs(section[2]) do
      table.insert(lines, string.format("  %-24s %s", entry[1], entry[2]))
    end
    table.insert(lines, "")
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local width = 58
  local height = math.min(#lines, vim.o.lines - 4)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
  })

  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, "<cmd>close<CR>", { buffer = buf, nowait = true })
  end
end, { desc = "Show keybind cheatsheet" })

vim.cmd("cnoreabbrev cheatsheet Cheatsheet")
vim.keymap.set("t", "<M-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  vim.schedule(ToggleClaude)
end, { desc = "Toggle Claude terminal (from terminal mode)" })

-- Word movement with Alt+Arrow
vim.keymap.set("n", "<M-Right>", "w", { desc = "Move word forward" })
vim.keymap.set("n", "<M-Left>", "b", { desc = "Move word backward" })
vim.keymap.set("i", "<M-Right>", "<C-Right>", { desc = "Move word forward" })
vim.keymap.set("i", "<M-Left>", "<C-Left>", { desc = "Move word backward" })

-- Toggle fullscreen for current window (Alt+Z)
local _fullscreen_restore = nil

local function toggle_fullscreen()
  if vim.fn.winnr("$") <= 1 then return end
  if _fullscreen_restore then
    vim.cmd(_fullscreen_restore)
    _fullscreen_restore = nil
  else
    _fullscreen_restore = vim.fn.winrestcmd()
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
  end
end

vim.keymap.set("n", "<M-z>", toggle_fullscreen, { desc = "Toggle fullscreen window" })
vim.keymap.set("t", "<M-z>", toggle_fullscreen, { desc = "Toggle fullscreen window (from terminal)" })
vim.keymap.set("i", "<M-z>", toggle_fullscreen, { desc = "Toggle fullscreen window (from insert)" })
