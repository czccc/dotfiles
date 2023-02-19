local utils = require("utils")

local diagnostics_indicator = function(_, _, diagnostics)
  local result = {}
  local symbols = { error = " ", warning = " ", info = " " }
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. count)
    end
  end
  local result_str = table.concat(result, " ")
  return #result_str > 0 and result_str or ""
end

local bufferline = {
  "akinsho/bufferline.nvim",
  lazy = true,
  event = "BufWinEnter",
  dependencies = {
    { "kyazdani42/nvim-web-devicons" },
    {
      "ojroques/nvim-bufdel",
      lazy = true,
      event = "BufWinEnter",
      opts = {
        next = "alternate", -- or 'alternate'
        quit = false,
      },
      keys = {
        { "<S-x>", "<cmd>BufDel<cr>", desc = "BufDel" },
        { "<Leader>c", "<cmd>BufDel<cr>", desc = "Close Buffer" },
      },
    },
  },
  opts = {
    highlights = {
      background = {
        italic = true,
      },
      buffer_selected = {
        bold = true,
      },
    },
    options = {
      numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
      close_command = "BufDel %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
      -- NOTE: this plugin is designed with this icon in mind,
      -- and so changing this is NOT recommended, this is intended
      -- as an escape hatch for people who cannot bear it for whatever reason
      indicator = {
        style = "icon",
        icon = "▎",
      },
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      --- name_formatter can be used to change the buffer's label in the bufferline.
      --- Please note some names can/will break the
      --- bufferline so use this at your discretion knowing that it has
      --- some limitations that will *NOT* be fixed.
      name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
        -- remove extension from markdown files for example
        if buf.name:match("%.md") then
          return vim.fn.fnamemodify(buf.name, ":t:r")
        end
      end,
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = diagnostics_indicator,
      offsets = {
        {
          filetype = "undotree",
          text = "Undotree",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "NeoTreeNormal",
          padding = 1,
          --[[ separator = true, -- use a "true" to enable the default, or set your own character ]]
        },
        {
          filetype = "DiffviewFiles",
          text = "Diff View",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "Outline",
          text = "Symbol Outline",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "neotest-summary",
          text = "Test Summary",
          highlight = "PanelHeading",
          padding = 1,
        },
      },
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      sort_by = "insert_after_current",
    },
  },
  init = function()
    utils.keymap.group("n", "<Leader>b", "BufferLine")
  end,
  keys = {
    { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "BufferLineCycleNext" },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufferLineCyclePrev" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },

    { "<Leader>bb", require("utils.telescope").dropdown("buffers"), desc = "Find Buffer" },
    { "<Leader>bc", "<cmd>BufDel<cr>", desc = "Close Current" },
    { "<Leader>bC", "<cmd>BufferLinePickClose<cr>", desc = "Buffer Pick Close" },
    { "<Leader>bf", "<cmd>b#<cr>", desc = "Previous" },
    { "<Leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close To Left" },
    { "<Leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close To Right" },
    { "<Leader>bj", "<cmd>BufferLineMovePrev<cr>", desc = "Move To Left" },
    { "<Leader>bk", "<cmd>BufferLineMoveNext<cr>", desc = "Move To Right" },
    { "<Leader>bp", "<cmd>BufferLinePick<cr>", desc = "Buffer Pick" },
    { "<Leader>bP", "<cmd>BufferLineTogglePin<cr>", desc = "Buffer Pin" },
    { "<Leader>bd", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort By Directory" },
    { "<Leader>be", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort By Extension" },
    { "<Leader>bt", "<cmd>BufferLineSortByTabs<cr>", desc = "Sort By Tab" },
  },
}

return { bufferline }
