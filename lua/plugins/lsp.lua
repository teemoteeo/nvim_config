return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    ft = { "c", "cpp", "python" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("clangd", {
        capabilities = capabilities,
        filetypes = { "c", "cpp", "objc", "objcpp" },
      })
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        filetypes = { "python" },
      })
      vim.lsp.enable({ "clangd", "pyright" })

      -- VS Code-style hover: rest the mouse on a symbol for 300ms to see its LSP info
      vim.o.mousemoveevent = true
      local timer = vim.uv.new_timer()
      local popup = nil -- { win = float winid, winid = source window, line = n, s = word start, e = word end }

      local function word_at(text, col)
        for s, e in text:gmatch("()[%w_]+()") do
          if col >= s and col < e then return s, e end
        end
      end

      local function close_popup()
        if popup and vim.api.nvim_win_is_valid(popup.win) then
          vim.api.nvim_win_close(popup.win, true)
        end
        popup = nil
      end

      local function show_hover(pos)
        if not vim.api.nvim_win_is_valid(pos.winid) or pos.line == 0 then return end
        local buf = vim.api.nvim_win_get_buf(pos.winid)
        if #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/hover" }) == 0 then return end
        local text = vim.api.nvim_buf_get_lines(buf, pos.line - 1, pos.line, false)[1] or ""
        local s, e = word_at(text, pos.column)
        if not s then return end

        vim.lsp.buf_request_all(buf, "textDocument/hover", function(client)
          return {
            textDocument = vim.lsp.util.make_text_document_params(buf),
            position = { line = pos.line - 1, character = vim.str_utfindex(text, client.offset_encoding, pos.column - 1, false) },
          }
        end, function(results)
          -- Mouse may have moved on while the server was answering
          local now = vim.fn.getmousepos()
          if now.winid ~= pos.winid or now.line ~= pos.line or now.column < s or now.column >= e then return end
          for _, res in pairs(results) do
            if res.result and res.result.contents then
              local lines = vim.lsp.util.convert_input_to_markdown_lines(res.result.contents)
              if #vim.tbl_filter(function(l) return l:match("%S") end, lines) > 0 then
                close_popup()
                local _, win = vim.lsp.util.open_floating_preview(lines, "markdown", {
                  relative = "mouse", border = "rounded", focusable = false,
                })
                popup = { win = win, winid = pos.winid, line = pos.line, s = s, e = e }
                return
              end
            end
          end
        end)
      end

      vim.keymap.set("n", "<MouseMove>", function()
        local pos = vim.fn.getmousepos()
        -- Keep the popup while the mouse stays on the same word
        if popup and pos.winid == popup.winid and pos.line == popup.line and pos.column >= popup.s and pos.column < popup.e then
          return
        end
        close_popup()
        timer:stop()
        timer:start(300, 0, vim.schedule_wrap(function() show_hover(pos) end))
      end, { desc = "LSP hover under mouse" })
    end,
  },
}
