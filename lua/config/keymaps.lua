vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<C-D>", "<C-D>zz")
vim.keymap.set("n", "<C-S>", "<C-B>zz")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<C-N>", ":bnext<CR>")
vim.keymap.set("n", "<C-P>", ":bprev<CR>")

-- Auto-pairs
vim.keymap.set("i", "$6", "()<Left>")
vim.keymap.set("i", "$2", "#include \"\"<Left>")
vim.keymap.set("i", "$3", "[]<Left>")
vim.keymap.set("i", "$4", "{}<Left>")
vim.keymap.set("i", "$1", "{<CR>}<Esc>O")
vim.keymap.set("i", "$q", "''<Left>")
vim.keymap.set("i", "$e", '""<Left>')

-- F1: 42 Header
vim.keymap.set("n", "<F1>", ":Stdheader<CR>")

-- F5: Compile & Run
function CompileRun()
  vim.cmd("write")
  local ft = vim.bo.filetype
  if ft == "c" then
    vim.cmd("!gcc % get_next_line_utils.c -o a.out && valgrind --leak-check=full -s ./a.out")
  elseif ft == "cpp" then
    vim.cmd("!g++ % -o %< && time ./%<")
  elseif ft == "java" then
    vim.cmd("!javac % && time java %")
  elseif ft == "sh" then
    vim.cmd("!time bash %")
  elseif ft == "python" then
    vim.cmd("!time python3 %")
  elseif ft == "go" then
    vim.cmd("!go build %< && time go run %")
  elseif ft == "matlab" then
    vim.cmd("!time octave %")
  end
end

vim.keymap.set("n", "<F5>", CompileRun)
vim.keymap.set("i", "<F5>", "<Esc>:lua CompileRun()<CR>")
vim.keymap.set("v", "<F5>", "<Esc>:lua CompileRun()<CR>")

-- F6: Norminette
function normcheck()
  vim.cmd("write")
  vim.cmd("!norminette %")
end

vim.keymap.set("n", "<F6>", normcheck)
vim.keymap.set("i", "<F6>", "<Esc>:lua normcheck()<CR>")

-- F7: Write + Make
function wmake()
  vim.cmd("write")
  vim.cmd("make")
  if vim.fn.filereadable("main.c") == 1 then
    vim.cmd("e main.c")
  end
  CompileRun()
end

vim.keymap.set("n", "<F7>", wmake)
vim.keymap.set("i", "<F7>", "<Esc>:lua wmake()<CR>")
vim.cmd("command Tree NvimTreeToggle")
vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>")
vim.cmd("command Tree NvimTreeToggle")
