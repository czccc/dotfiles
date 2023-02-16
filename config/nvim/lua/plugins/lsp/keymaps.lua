local utils = require("utils")

local M = {}

M.keys = {
  { "ga", vim.lsp.buf.range_code_action, mode = "v", desc = "Code Actions", has = "codeAction" },
  { "ga", vim.lsp.buf.code_action, mode = "n", desc = "Code Actions", has = "codeAction" },
  { "gF", require("plugins.lsp.utils").format, desc = "Format Code", has = "documentFormatting" },
  { "gF", require("plugins.lsp.utils").format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
  { "gL", vim.lsp.codelens.run, desc = "Code Lens", has = "codeLens" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
  { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },

  { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Show Hover" },
  { "gp", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Finder" },
  { "gR", "<cmd>Lspsaga rename<cr>", desc = "Rename Symbol", has = "rename" },
  { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Goto Definition" },
  { "gD", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },

  { "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Line Diagnostics" },
  { "gB", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Show Buffer Diagnostics" },
  { "gC", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Show Cursor Diagnostics" },

  { "<Leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
  { "<Leader>lR", "<cmd>LspRestart<cr>", desc = "Lsp Restart" },
  { "<Leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Lsp Outline" },

  { "<Leader>ls", utils.telescope.builtin("lsp_document_symbols"), desc = "Document Symbols" },
  { "<Leader>lS", utils.telescope.builtin("lsp_dynamic_workspace_symbols"), desc = "Workspace Symbols" },
  { "<Leader>ld", utils.telescope.ivy("diagnostics", { bufnr = 0 }), desc = "Buffer Diagnostic" },
  { "<Leader>lD", utils.telescope.builtin("diagnostics"), desc = "Workspace Diagnostic" },
  { "<Leader>lr", utils.telescope.builtin("lsp_references"), desc = "LSP Reference" },
  { "<Leader>lO", utils.telescope.builtin("lsp_implementations"), desc = "LSP Implementations" },
}

function M.set_keymaps(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.keys) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = true
      opts.buffer = buffer
      utils.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

return M
