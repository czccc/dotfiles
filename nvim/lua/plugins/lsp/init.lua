local M = {}
local Log = require "core.log"
local autocmds = require "core.autocmds"

M.packers = {
  { "neovim/nvim-lspconfig" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "williamboman/nvim-lsp-installer" },
  {
    "filipdutescu/renamer.nvim",
    config = function()
      require("plugins.lsp.renamer").config()
    end,
  },
  {
    "folke/lua-dev.nvim",
    module = "lua-dev",
  },
  {
    "simrat39/rust-tools.nvim",
    config = function()
      require("plugins.lsp.lang.rust_tools").setup()
    end,
    ft = { "rust", "rs" },
  },
  {
    "p00f/clangd_extensions.nvim",
    config = function()
      require("plugins.lsp.lang.clangd_extension").setup()
    end,
    ft = { "c", "cpp", "objc", "objcpp" },
  },
}

M.config = require "plugins.lsp.config"

local function lsp_highlight_document(client)
  if M.config.document_highlight == false then
    return -- we don't need further
  end
  autocmds.enable_lsp_document_highlight(client.id)
end

local function lsp_code_lens_refresh(client)
  if M.config.code_lens_refresh == false then
    return
  end

  if client.resolved_capabilities.code_lens then
    autocmds.enable_code_lens_refresh()
  end
end

local function add_lsp_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  -- Remap using which_key
  local wk = require "plugins.which_key"
  if wk:load() then
    for mode_name, mode_char in pairs(mappings) do
      wk.register(M.config.buffer_mappings[mode_name], { mode = mode_char, buffer = bufnr })
    end
    wk.register(M.config.which_key_mapping)
  end
  -- Remap using nvim api
  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(M.config.buffer_mappings[mode_name]) do
      vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], { noremap = true, silent = true })
    end
  end
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

local function select_default_formater(client)
  if client.name == "null-ls" or not client.resolved_capabilities.document_formatting then
    return
  end
  Log:debug("Checking for formatter overriding for " .. client.name)
  local formatters = require "plugins.lsp.null-ls.formatters"
  local client_filetypes = client.config.filetypes or {}
  for _, filetype in ipairs(client_filetypes) do
    if #vim.tbl_keys(formatters.list_registered(filetype)) > 0 then
      Log:debug("Formatter overriding detected. Disabling formatting capabilities for " .. client.name)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  end
end

function M.common_on_exit(_, _)
  if M.config.document_highlight then
    autocmds.disable_lsp_document_highlight()
  end
  if M.config.code_lens_refresh then
    autocmds.disable_code_lens_refresh()
  end
end

function M.common_on_init(client, _)
  -- if M.config.on_init_callback then
  --   M.config.on_init_callback(client, bufnr)
  --   Log:debug "Called lsp.on_init_callback"
  --   return
  -- end
  select_default_formater(client)
end

function M.common_on_attach(client, bufnr)
  -- if M.config.on_attach_callback then
  --   M.config.on_attach_callback(client, bufnr)
  --   Log:debug "Called lsp.on_attach_callback"
  -- end
  lsp_highlight_document(client)
  lsp_code_lens_refresh(client)
  add_lsp_buffer_keybindings(bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

function M.setup()
  Log:debug "Setting up LSP support"

  local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
  if not lsp_status_ok then
    return
  end
  lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    capabilities = M.common_capabilities(),
  })

  for _, sign in ipairs(M.config.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.diagnostic.config(M.config.diagnostics)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, M.config.float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, M.config.float)

  local lsp_installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
  if lsp_installer_status_ok then
    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server instances instead (see example below).
    lsp_installer.on_server_ready(function(server)
      require("plugins.lsp.manager").setup(server.name)
    end)
  end

  require("plugins.lsp.null-ls").setup()

  require("core.autocmds").configure_format_on_save()
end

return M
