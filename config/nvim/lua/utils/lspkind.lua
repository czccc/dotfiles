local lspkind = {}
local fmt = string.format

lspkind.kind = {
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

local function get_symbol(kind)
  local symbol = lspkind.kind[kind]
  return symbol or lspkind.kind.Unknown
end

lspkind.modes = {
  ["text"] = function(kind)
    return kind
  end,
  ["text_symbol"] = function(kind)
    local symbol = get_symbol(kind)
    return fmt("%s %s", kind, symbol)
  end,
  ["symbol_text"] = function(kind)
    local symbol = get_symbol(kind)
    return fmt("%s %s", symbol, kind)
  end,
  ["symbol"] = function(kind)
    local symbol = get_symbol(kind)
    return fmt("%s", symbol)
  end,
}

for k, v in pairs(lspkind.kind) do
  require("vim.lsp.protocol").CompletionItemKind[k] = v
end

function lspkind.cmp_format(opts)
  opts = opts or {}
  if opts.preset or opts.symbol_map then
    lspkind.init(opts)
  end

  return function(entry, vim_item)
    if opts.before then
      vim_item = opts.before(entry, vim_item)
    end

    vim_item.kind = "  " .. lspkind.modes[opts.mode or "symbol_text"](vim_item.kind)

    if opts.menu ~= nil then
      vim_item.menu = opts.menu[entry.source.name]
    end

    if opts.maxwidth ~= nil and #vim_item.abbr > opts.maxwidth then
      vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth - 3) .. "..."
    end

    return vim_item
  end
end

return lspkind
