-- local path = require "utils.path"

return {
  -- templates_dir = path.join(path.runtime_dir, "site", "after", "ftplugin"),
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
      ["g["] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Diagnostic Next" },
      ["g]"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Diagnostic Prev" },
      ["ga"] = { "<cmd>lua require('plugins.telescope').code_actions()<CR>", "Code Action" },
      ["gd"] = { "<cmd>lua require('plugins.telescope').lsp_definitions()<CR>", "Goto Definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
      ["gr"] = { "<cmd>lua require('plugins.telescope').lsp_references()<CR>", "Goto references" },
      ["gI"] = { "<cmd>lua require('plugins.telescope').lsp_implementations()<CR>", "Goto Implementation" },
      ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },
      ["gt"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
      ["gp"] = { "<cmd>lua require('plugins.lsp.peek').Peek('definition')<CR>", "Peek definition" },
      ["gl"] = { "<cmd>lua require('plugins.lsp.utils').show_line_diagnostics()<CR>", "Line diagnostics" },
    },
    insert_mode = {},
    visual_mode = {},
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
