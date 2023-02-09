local utils = require("utils.fn")
local M = {}

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  return vim.lsp.buf.format({
    timeout = 1000,
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

M.autoformat = true

function M.enable_format_on_save(client, buf)
  M.autoformat = true
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. buf, { clear = true }),
      buffer = buf,
      callback = function()
        if M.autoformat then
          M.format()
        end
      end,
    })
  end
end

function M.disable_format_on_save()
  M.autoformat = false
end

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  return capabilities
end

function M.common_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_autocmd(
      { "CursorHold" },
      { buffer = bufnr, callback = utils.wrap(vim.lsp.buf.document_highlight, client.id) }
    )
    vim.api.nvim_create_autocmd({ "CursorMoved" }, { buffer = bufnr, callback = vim.lsp.buf.clear_references })
  end
  if client.supports_method("textDocument/codeLens") then
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, { buffer = bufnr, callback = vim.lsp.codelens.refresh })
    vim.api.nvim_create_autocmd({ "InsertLeave" }, { buffer = bufnr, callback = vim.lsp.codelens.display })
  end
  if client.supports_method("textDocument/formatting") then
    M.enable_format_on_save(client, bufnr)
    utils.keymap.set("n", "[of", M.enable_format_on_save, { desc = "Format On Save", buffer = bufnr })
    utils.keymap.set("n", "]of", M.disable_format_on_save, { desc = "Format On Save", buffer = bufnr })
  end
end

return M
