local M = {}
local Log = require "core.log"
local path = require "utils.path"
local autocmds = require "core.autocmds"

M.packers = {
  { "neovim/nvim-lspconfig" },
  -- { "tamago324/nlsp-settings.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "williamboman/nvim-lsp-installer" },
  {
    "filipdutescu/renamer.nvim",
    config = function()
      require("plugins.lsp.renamer").config()
    end,
  },
}

M.config = function()
  gconf.lsp = require "plugins.lsp.config"
  gconf.plugins.which_key.mappings["l"] = {
    name = "LSP",
    a = { "<cmd>lua require('plugins.telescope').code_actions()<cr>", "Code Action" },
    f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
    j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    -- R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    R = { "<cmd>lua require('renamer').rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    w = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    W = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },

    d = { "<cmd>lua require('plugins.telescope').lsp_definitions()<CR>", "Goto Definition" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
    r = { "<cmd>lua require('plugins.telescope').lsp_references()<CR>", "Goto references" },
    i = { "<cmd>lua require('plugins.telescope').lsp_implementations()<CR>", "Goto Implementation" },
    h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },

    v = { "<cmd>ClangdSwitchSourceHeader<CR>", "show signature help" },

    p = {
      name = "Peek",
      d = { "<cmd>lua require('lvim.lsp.peek').Peek('definition')<cr>", "Definition" },
      t = { "<cmd>lua require('lvim.lsp.peek').Peek('typeDefinition')<cr>", "Type Definition" },
      i = { "<cmd>lua require('lvim.lsp.peek').Peek('implementation')<cr>", "Implementation" },
    },
    u = {
      name = "Utils",
      i = { "<cmd>LspInfo<cr>", "Lsp Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Install" },
      r = { "<cmd>LspRestart<cr>", "Restart" },
    },
    t = {
      name = "+Trouble",
      d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnosticss" },
      f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
      l = { "<cmd>Trouble loclist<cr>", "LocationList" },
      q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
      r = { "<cmd>Trouble lsp_references<cr>", "References" },
      t = { "<cmd>TodoTrouble<cr>", "Todo" },
      w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnosticss" },
    },
  }
end

local function lsp_highlight_document(client)
  if gconf.lsp.document_highlight == false then
    return -- we don't need further
  end
  autocmds.enable_lsp_document_highlight(client.id)
end

local function lsp_code_lens_refresh(client)
  if gconf.lsp.code_lens_refresh == false then
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

  if gconf.plugins.which_key.active then
    -- Remap using which_key
    local status_ok, wk = pcall(require, "which-key")
    if not status_ok then
      return
    end
    for mode_name, mode_char in pairs(mappings) do
      wk.register(gconf.lsp.buffer_mappings[mode_name], { mode = mode_char, buffer = bufnr })
    end
  else
    -- Remap using nvim api
    for mode_name, mode_char in pairs(mappings) do
      for key, remap in pairs(gconf.lsp.buffer_mappings[mode_name]) do
        vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], { noremap = true, silent = true })
      end
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
  if gconf.lsp.document_highlight then
    autocmds.disable_lsp_document_highlight()
  end
  if gconf.lsp.code_lens_refresh then
    autocmds.disable_code_lens_refresh()
  end
end

function M.common_on_init(client, bufnr)
  if gconf.lsp.on_init_callback then
    gconf.lsp.on_init_callback(client, bufnr)
    Log:debug "Called lsp.on_init_callback"
    return
  end
  select_default_formater(client)
end

function M.common_on_attach(client, bufnr)
  if gconf.lsp.on_attach_callback then
    gconf.lsp.on_attach_callback(client, bufnr)
    Log:debug "Called lsp.on_attach_callback"
  end
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

  for _, sign in ipairs(gconf.lsp.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  local config = {
    virtual_text = gconf.lsp.diagnostics.virtual_text,
    signs = gconf.lsp.diagnostics.signs,
    underline = gconf.lsp.diagnostics.underline,
    update_in_insert = gconf.lsp.diagnostics.update_in_insert,
    severity_sort = gconf.lsp.diagnostics.severity_sort,
    float = gconf.lsp.diagnostics.float,
  }
  vim.diagnostic.config(config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, gconf.lsp.float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, gconf.lsp.float)

  -- local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
  -- if lsp_settings_status_ok then
  --   lsp_settings.setup {
  --     config_home = path.join(path.config_dir, "nlsp-settings"),
  --     local_settings_dir = ".nlsp-settings",
  --     local_settings_root_markers = { ".git" },
  --     append_default_schemas = true,
  --     loader = "json",
  --   }
  -- end

  local lsp_installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
  if lsp_installer_status_ok then
    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server instances instead (see example below).
    lsp_installer.on_server_ready(function(server)
      require("plugins.lsp.manager").setup(server.name)
    end)
  end

  require("plugins.lsp.null-ls").setup()

  autocmds.configure_format_on_save()
end

return M
