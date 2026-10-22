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

-- Open PDFs as extracted text (requires pdftotext from poppler-utils)
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function(args)
    if vim.fn.executable("pdftotext") == 0 then
      vim.notify("pdftotext not found, cannot render PDF", vim.log.levels.ERROR)
      return
    end
    local lines = vim.fn.systemlist({ "pdftotext", "-layout", args.match, "-" })
    if vim.v.shell_error ~= 0 then
      vim.notify("pdftotext failed: " .. table.concat(lines, " "), vim.log.levels.ERROR)
      return
    end
    vim.bo[args.buf].modifiable = true
    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
    vim.bo[args.buf].modified = false
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].readonly = true
    vim.bo[args.buf].buftype = "nowrite"
    vim.bo[args.buf].swapfile = false
  end,
})

-- Show line count at end of each function/class definition line
local fn_ns = vim.api.nvim_create_namespace("fn_line_count")
local function mark_functions(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then return end
  vim.api.nvim_buf_clear_namespace(buf, fn_ns, 0, -1)
  local skip, fns = {}, {} -- skip: rows holding only comments/docstrings
  local function skip_rows(node)
    local sr, sc, er = node:range()
    local line = vim.api.nvim_buf_get_lines(buf, sr, sr + 1, false)[1] or ""
    if (line:find("%S") or 1) - 1 < sc then sr = sr + 1 end -- code before it on first line
    for r = sr, er do skip[r] = true end
  end
  local function walk(node)
    for child in node:iter_children() do
      local t = child:type()
      if t == "comment" then skip_rows(child) end
      -- ponytail: name heuristic covers c/cpp/lua/python; add node types if a language is missed
      if (t:match("function") or t:match("class") or t:match("method"))
        and (t:match("definition") or t:match("declaration") or t:match("specifier")) then
        table.insert(fns, child)
        -- Python docstring: first statement of body that is a bare string
        local body = child:field("body")[1]
        local first = body and body:named_child(0)
        if first and first:type() == "expression_statement" and first:named_child(0)
          and first:named_child(0):type() == "string" then
          skip_rows(first)
        end
      end
      walk(child)
    end
  end
  walk(parser:parse()[1]:root())
  for _, fn in ipairs(fns) do
    local srow, _, erow = fn:range()
    if erow > srow then
      -- Count only the body: skip declaration line(s), and { } lines for brace languages
      local body = fn:field("body")[1]
      local bs, be = srow + 1, erow
      if body then
        bs, _, be = body:range()
        if vim.treesitter.get_node_text(body, buf):sub(1, 1) == "{" then bs, be = bs + 1, be - 1 end
      end
      local count = 0
      for r = bs, be do
        if not skip[r] then count = count + 1 end
      end
      vim.api.nvim_buf_set_extmark(buf, fn_ns, srow, 0, {
        virt_text = { { "  " .. count .. (count == 1 and " line" or " lines"), "Comment" } },
      })
    end
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
  callback = function(args) mark_functions(args.buf) end,
})
