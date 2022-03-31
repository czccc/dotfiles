local M = {}

M.packer = {
  {
    -- "github/copilot.vim",
    "gelfand/copilot.vim",
    config = function()
      require("plugins.copilot").setup()
    end,
  },
  {
    "hrsh7th/cmp-copilot",
    config = function()
      gconf.plugins.cmp.formatting.source_names["copilot"] = "(Copilot)"
      table.insert(gconf.plugins.cmp.sources, { name = "copilot" })
    end,
  },
}

M.config = function()
  -- gconf.keys.insert_mode["<C-G>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
  -- local cmp = require "cmp"
  -- gconf.plugins.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "s" })
  -- gconf.plugins.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "s" })
end

M.test = function()
  -- code here
  M.config()
  M.config()
end

M.setup = function()
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""
  vim.g.copilot_filetypes = {
    ["*"] = false,
    python = true,
    lua = true,
    go = true,
    rust = true,
    html = true,
    c = true,
    cpp = true,
    java = true,
    javascript = true,
    typescript = true,
    javascriptreact = true,
    typescriptreact = true,
    terraform = true,
  }
  vim.cmd [[ imap <silent><script><expr> <C-G> copilot#Accept("\<CR>") ]]
end

function M.tab(fallback)
  local methods = require("plugins.cmp").methods
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  local copilot_keys = vim.fn["copilot#Accept"] ""
  if cmp.visible() then
    cmp.select_next_item()
  elseif vim.api.nvim_get_mode().mode == "c" then
    fallback()
  elseif copilot_keys ~= "" then -- prioritise copilot over snippets
    -- Copilot keys do not need to be wrapped in termcodes
    -- vim.cmd "copilot#Accept('<CR>')"
    vim.api.nvim_feedkeys(copilot_keys, "i", true)
    -- vim.api.nvim_replace_termcodes("<C-G>", true, true, true)
  elseif luasnip.expandable() then
    luasnip.expand()
  elseif methods.jumpable() then
    luasnip.jump(1)
  elseif methods.check_backspace() then
    fallback()
  elseif methods.is_emmet_active() then
    return vim.fn["cmp#complete"]()
  else
    fallback()
  end
end

function M.shift_tab(fallback)
  local methods = require("plugins.cmp").methods
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  -- local copilot_keys = vim.fn["copilot#Accept"]()
  if cmp.visible() then
    cmp.select_prev_item()
  elseif vim.api.nvim_get_mode().mode == "c" then
    fallback()
  elseif methods.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
    -- if copilot_keys ~= "" then
    --   methods.feedkeys(copilot_keys, "i")
    -- else
    --   methods.feedkeys("<Plug>(Tabout)", "")
    -- end
  end
end

return M
