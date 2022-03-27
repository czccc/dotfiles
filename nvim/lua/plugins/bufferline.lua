local M = {}

M.packers = {
  {
    "akinsho/bufferline.nvim",
    event = "BufWinEnter",
    disable = false,
    config = function()
      require("plugins.bufferline").setup()
    end,
  },
  {
    "ojroques/nvim-bufdel",
    event = "BufWinEnter",
    disable = false,
    config = function()
      require("bufdel").setup {
        next = "alternate", -- or 'alternate'
        quit = false,
      }
    end,
  },
}

local function is_ft(b, ft)
  return vim.bo[b].filetype == ft
end

local function diagnostics_indicator(_, _, diagnostics)
  local result = {}
  local symbols = { error = " ", warning = " ", info = " " }
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. count)
    end
  end
  result = table.concat(result, " ")
  return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
  local logs = vim.tbl_filter(function(b)
    return is_ft(b, "log")
  end, buf_nums)
  if vim.tbl_isempty(logs) then
    return true
  end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr "$"
  local is_log = is_ft(buf, "log")
  if last_tab == 1 then
    return true
  end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

M.config = function()
  gconf.plugins.bufferline = {
    keymap = {
      normal_mode = {
        ["<S-x>"] = ":BufDel<CR>",
        ["<TAB>"] = ":BufferLineCycleNext<CR>",
        ["<S-TAB>"] = ":BufferLineCyclePrev<CR>",
        ["<A-<>"] = ":BufferLineMovePrev<CR>",
        ["<A->>"] = ":BufferLineMoveNext<CR>",
      },
    },
    highlights = {
      background = {
        gui = "italic",
      },
      buffer_selected = {
        gui = "bold",
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
      indicator_icon = "▎",
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
        if buf.name:match "%.md" then
          return vim.fn.fnamemodify(buf.name, ":t:r")
        end
      end,
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = diagnostics_indicator,
      -- NOTE: this will be called a lot so don't do any heavy processing here
      custom_filter = custom_filter,
      offsets = {
        {
          filetype = "undotree",
          text = "Undotree",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "DiffviewFiles",
          text = "Diff View",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "flutterToolsOutline",
          text = "Flutter Outline",
          highlight = "PanelHeading",
        },
        {
          filetype = "packer",
          text = "Packer",
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
      sort_by = "id",
    },
  }
  gconf.plugins.which_key.mappings["c"] = { "<cmd>BufDel<CR>", "Close Buffer" }
  gconf.plugins.which_key.mappings["b"] = {
    name = "Buffers",
    b = { "<cmd>lua require('plugins.telescope').find_buffers()<cr>", "Find Buffers" },
    c = { "<cmd>BufDel<cr>", "Close Current" },
    f = { "<cmd>b#<cr>", "Previous" },
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close to Left" },
    l = { "<cmd>BufferLineCloseRight<cr>", "Close to Right" },
    j = { "<cmd>BufferLineMovePrev<cr>", "Move Previous" },
    k = { "<cmd>BufferLineMoveNext<cr>", "Move Next" },
    p = { "<cmd>BufferLinePick<cr>", "Buffer Pick" },
    d = { "<cmd>BufferLineSortByDirectory<cr>", "Sort by Directory" },
    L = { "<cmd>BufferLineSortByExtension<cr>", "Sort by Extension" },
    n = { "<cmd>BufferLineSortByTabs<cr>", "Sort by Tabs" },

    ["g"] = {
      name = "Buffer Goto",
      ["1"] = { "<cmd>BufferLineGoToBuffer 1<cr>", "BufferGoto 1" },
      ["2"] = { "<cmd>BufferLineGoToBuffer 2<cr>", "BufferGoto 2" },
      ["3"] = { "<cmd>BufferLineGoToBuffer 3<cr>", "BufferGoto 3" },
      ["4"] = { "<cmd>BufferLineGoToBuffer 4<cr>", "BufferGoto 4" },
      ["5"] = { "<cmd>BufferLineGoToBuffer 5<cr>", "BufferGoto 5" },
      ["6"] = { "<cmd>BufferLineGoToBuffer 6<cr>", "BufferGoto 6" },
      ["7"] = { "<cmd>BufferLineGoToBuffer 7<cr>", "BufferGoto 7" },
      ["8"] = { "<cmd>BufferLineGoToBuffer 8<cr>", "BufferGoto 8" },
      ["9"] = { "<cmd>BufferLineGoToBuffer 9<cr>", "BufferGoto 9" },
    },
  }
end

M.setup = function()
  require("core.keymap").load(gconf.plugins.bufferline.keymap)
  ---@diagnostic disable-next-line: different-requires
  require("bufferline").setup {
    options = gconf.plugins.bufferline.options,
    highlights = gconf.plugins.bufferline.highlights,
  }
end

return M
