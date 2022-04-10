-- local path = require "utils.path"

return {
  setup = {},
  diagnostics = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
        end
        return t.message
      end,
    },
  },
  document_highlight = true,
  code_lens_refresh = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  },
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_servers_installation = true,
  buffer_mappings = {
    normal_mode = {
      ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
      ["g]"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Diagnostic Next" },
      ["g["] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Diagnostic Prev" },
      ["ga"] = { "<cmd>lua require('plugins.telescope').code_actions()<CR>", "Code Action" },
      ["gd"] = { "<cmd>lua require('plugins.telescope').lsp_definitions()<CR>", "Goto Definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
      ["gr"] = { "<cmd>lua require('plugins.telescope').lsp_references()<CR>", "Goto references" },
      ["gI"] = { "<cmd>lua require('plugins.telescope').lsp_implementations()<CR>", "Goto Implementation" },
      ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },
      ["gt"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
      ["gp"] = { "<cmd>lua require('plugins.lsp.peek').Peek('definition')<CR>", "Peek definition" },
      ["gl"] = { "<cmd>lua require('plugins.lsp.utils').show_line_diagnostics()<CR>", "Line diagnostics" },
      ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
      ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
    },
    insert_mode = {},
    visual_mode = {},
  },
  which_key_mapping = {
    ["l"] = {
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
    },
  },
  null_ls = {
    setup = {
      debounce = 150,
      save_after_format = true,
    },
    config = {},
  },
  override = {
    "angularls",
    "ansiblels",
    "ccls",
    "csharp_ls",
    "cssmodules_ls",
    "denols",
    "ember",
    "emmet_ls",
    "eslint",
    "eslintls",
    "golangci_lint_ls",
    "grammarly",
    "graphql",
    "jedi_language_server",
    "ltex",
    "phpactor",
    "psalm",
    "pylsp",
    "quick_lint_js",
    "remark_ls",
    "rome",
    "scry",
    "solang",
    "solidity_ls",
    "sorbet",
    "sourcekit",
    "spectral",
    "sqlls",
    "sqls",
    "stylelint_lsp",
    "tailwindcss",
    "tflint",
    "verible",
    "vuels",
    "zeta_note",
    "zk",
  },
}
