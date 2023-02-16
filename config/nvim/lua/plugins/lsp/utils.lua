local utils = require("utils")

local M = {}

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

local enabled = true

function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end

function M.enable_diagnostics()
  enabled = true
  vim.diagnostic.enable()
end

function M.disable_diagnostics()
  enabled = false
  vim.diagnostic.disable()
end

function M.diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil

  if require("utils").has("lspsaga.nvim") then
    if next then
      return function()
        require("lspsaga.diagnostic"):goto_next({ severity = severity })
      end
    else
      return function()
        require("lspsaga.diagnostic"):goto_prev({ severity = severity })
      end
    end
  end

  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

M.autoformat = true

function M.toggle_format()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    vim.notify("Enabled format on save", { title = "Format" })
  else
    vim.warn("Disabled format on save", { title = "Format" })
  end
end

function M.enable_format()
  M.autoformat = true
end

function M.disable_format()
  M.autoformat = false
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false then
    return
  end
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  }, { timeout_ms = 1000 }))
end

function M.set_keymaps(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  utils.keymap.set("n", "[d", M.diagnostic_goto(false), { desc = "Previous Diagnostic", buffer = bufnr })
  utils.keymap.set("n", "]d", M.diagnostic_goto(true), { desc = "Next Diagnostic", buffer = bufnr })
  utils.keymap.set("n", "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Previous Error", buffer = bufnr })
  utils.keymap.set("n", "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error", buffer = bufnr })
  utils.keymap.set("n", "[w", M.diagnostic_goto(false, "WARN"), { desc = "Previous Warning", buffer = bufnr })
  utils.keymap.set("n", "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning", buffer = bufnr })
  utils.keymap.set("n", "[od", M.enable_diagnostics, { desc = "Diagnostics", buffer = bufnr })
  utils.keymap.set("n", "]od", M.disable_diagnostics, { desc = "Diagnostics", buffer = bufnr })
  utils.keymap.set("n", "yod", M.toggle_diagnostics, { desc = "Diagnostics", buffer = bufnr })

  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_autocmd(
      { "CursorHold", "CursorHoldI" },
      { buffer = bufnr, callback = utils.wrap(vim.lsp.buf.document_highlight, client.id) }
    )
    vim.api.nvim_create_autocmd(
      { "CursorMoved", "CursorMovedI" },
      { buffer = bufnr, callback = vim.lsp.buf.clear_references }
    )
  end

  if client.supports_method("textDocument/codeLens") then
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, { buffer = bufnr, callback = vim.lsp.codelens.refresh })
    vim.api.nvim_create_autocmd({ "InsertLeave" }, { buffer = bufnr, callback = vim.lsp.codelens.display })
  end

  -- dont format if client disabled it
  if
    client.supports_method("textDocument/formatting")
    and not (
      client.config
      and client.config.capabilities
      and client.config.capabilities.documentFormattingProvider == false
    )
  then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
      buffer = bufnr,
      callback = function()
        if M.autoformat then
          M.format()
        end
      end,
    })
    utils.keymap.set("n", "[of", M.enable_format, { desc = "Format On Save", buffer = bufnr })
    utils.keymap.set("n", "]of", M.disable_format, { desc = "Format On Save", buffer = bufnr })
    utils.keymap.set("n", "yof", M.toggle_format, { desc = "Format On Save", buffer = bufnr })
  end
end

return M
