local M = {}

M.lspkind = {
  Array = "",
  Boolean = " ",
  Class = "ﴯ",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  -- Field = "ﰠ",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  -- Module = "",
  Module = "",
  Operator = "",
  -- Property = "ﰠ",
  Property = "",
  Reference = "",
  -- Snippet = "",
  Snippet = "",
  Struct = "פּ",
  Text = "",
  -- TypeParameter = "",
  TypeParameter = "",
  -- Unit = "塞",
  Unit = "",
  Value = "",
  -- Variable = "",
  Variable = "",
  Unknown = "",
}

M.diagnostic = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

return M
