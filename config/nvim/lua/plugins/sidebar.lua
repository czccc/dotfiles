return {
  {
    "simrat39/symbols-outline.nvim",
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false,
      position = "right",
      relative_width = true,
      width = 12,
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      preview_bg_highlight = "Pmenu",
      keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
    },
    init = function()
      vim.cmd([[ highlight! link FocusedSymbol Visual ]])
    end,
    cmd = { "SymbolsOutline", "SymbolsOutlineClose" },
    keys = { { "<Leader>us", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  },
  {
    "mbbill/undotree",
    init = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
    keys = {
      { "<Leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
    cmd = { "UndotreeToggle" },
  },
}
