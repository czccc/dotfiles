local M = {}

M.packer = {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("plugins.lualine").setup()
  end,
  disable = false,
}
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  wide_window = function()
    return vim.fn.winwidth(0) > 80
  end,
  large_window = function()
    return vim.fn.winwidth(0) > 130
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

local components = {
  left = {
    function()
      return "▊"
    end,
    color = { fg = colors.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
  },
  mode = {
    function()
      return " "
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  },
  mode1 = {
    function()
      local mod = vim.fn.mode()
      local icons = {
        normal = "",
        insert = "",
        visual = "",
        command = "",
        replace = "",
      }
      if mod == "n" or mod == "no" or mod == "nov" then
        return icons.normal
      elseif mod == "i" or mod == "ic" or mod == "ix" then
        return icons.insert
      elseif mod == "V" or mod == "v" or mod == "vs" or mod == "Vs" or mod == "cv" then
        return icons.visual
      elseif mod == "c" or mod == "ce" then
        return icons.command
      elseif mod == "r" or mod == "rm" or mod == "r?" or mod == "R" or mod == "Rc" or mod == "Rv" or mod == "Rv" then
        return icons.replace
      end
      return icons.normal
    end,
    color = { fg = colors.blue, gui = "bold" },
    padding = { left = 1, right = 1 },
  },
  branch = {
    "b:gitsigns_head",
    icon = " ",
    color = { fg = colors.blue, gui = "bold" },
    cond = function()
      return conditions.check_git_workspace() and conditions.large_window()
    end,
    padding = 0,
  },
  filename = {
    "filename",
    file_status = true, -- Displays file status (readonly status, modified status)
    path = 1,
    shorting_target = 80, -- Shortens path to leave 80 spaces in the window
    symbols = {
      modified = "[+]", -- Text to show when the file is modified.
      readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
      unnamed = "[No Name]", -- Text to show for unnamed buffers.
    },
    cond = conditions.buffer_not_empty,
    color = { gui = "bold" },
    padding = { left = 0, right = 1 },
  },
  diff = {
    "diff",
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    padding = { left = 0, right = 0 },
    cond = nil,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    cond = conditions.wide_window,
  },
  treesitter = {
    function()
      local b = vim.api.nvim_get_current_buf()
      if next(vim.treesitter.highlighter.active[b]) then
        return ""
      end
      return ""
    end,
    color = { fg = colors.green },
    cond = conditions.large_window,
  },
  lsp = {
    function(msg)
      msg = msg or "LS Inactive"
      local buf_clients = vim.lsp.buf_get_clients()
      if next(buf_clients) == nil then
        -- TODO: clean up this if statement
        if type(msg) == "boolean" or #msg == 0 then
          return "LS Inactive"
        end
        return msg
      end
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      -- add formatter
      local formatters = require "plugins.lsp.null-ls.formatters"
      local supported_formatters = formatters.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      local linters = require "plugins.lsp.null-ls.linters"
      local supported_linters = linters.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_linters)

      return "[" .. table.concat(buf_client_names, ", ") .. "]"
    end,
    color = { gui = "bold" },
    cond = conditions.large_window,
  },
  lsp_progress = {
    function()
      local messages = vim.lsp.util.get_progress_messages()
      if #messages == 0 then
        return ""
      end
      local status = {}
      for _, msg in pairs(messages) do
        table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
      end
      local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      -- local spinners = { " ", " ", " ", " ", " ", " ", " ", " ", " ", " " }
      -- local spinners = { " ", " ", " ", " ", " ", " ", " ", " ", " " }
      local ms = vim.loop.hrtime() / 1000000
      local frame = math.floor(ms / 60) % #spinners
      if not conditions.large_window() then
        return spinners[frame + 1]
      else
        return spinners[frame + 1] .. " " .. table.concat(status, " | ")
      end
    end,
    -- cond = conditions.large_window,
  },
  location = {
    "location",
    -- cond = conditions.wide_window,
    color = { fg = colors.yellow },
  },
  progress = { "progress", cond = conditions.wide_window, color = {} },
  spaces = {
    function()
      if not vim.api.nvim_buf_get_option(0, "expandtab") then
        if not conditions.large_window() then
          return "T: " .. vim.api.nvim_buf_get_option(0, "tabstop")
        end
        return "Tab size: " .. vim.api.nvim_buf_get_option(0, "tabstop")
      end
      local size = vim.api.nvim_buf_get_option(0, "shiftwidth")
      if size == 0 then
        size = vim.api.nvim_buf_get_option(0, "tabstop")
      end
      if not conditions.large_window() then
        return "S: " .. size
      end
      return "Spaces: " .. size
    end,
    cond = conditions.wide_window,
    color = { fg = colors.orange },
  },
  encoding = {
    "o:encoding",
    fmt = string.upper,
    color = { fg = colors.orange },
    cond = conditions.wide_window,
  },
  fileformat = {
    "fileformat",
    icons_enabled = true,
    symbols = {
      unix = "LF",
      dos = "CRLF",
      mac = "CR",
    },
    fmt = string.upper,
    color = { fg = colors.green },
    cond = conditions.wide_window,
  },
  filesize = {
    function()
      local function format_file_size(file)
        local size = vim.fn.getfsize(file)
        if size <= 0 then
          return ""
        end
        local sufixes = { "b", "k", "m", "g" }
        local i = 1
        while size > 1024 do
          size = size / 1024
          i = i + 1
        end
        return string.format("%.1f%s", size, sufixes[i])
      end
      local file = vim.fn.expand "%:p"
      if string.len(file) == 0 then
        return ""
      end
      return format_file_size(file)
    end,
    color = { fg = colors.green },
    cond = conditions.wide_window,
  },
  clock = {
    function()
      return " " .. os.date "%H:%M"
    end,
    color = { fg = colors.purple },
    cond = conditions.large_window,
  },
  keymap = {
    function()
      if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
        return "⌨ " .. vim.b.keymap_name
      end
      return ""
    end,
    cond = conditions.wide_window,
  },
  filetype = {
    "filetype",
    icon_only = true,
    cond = conditions.wide_window,
  },
  filetype1 = {
    "filetype",
    icon_only = false,
    cond = conditions.large_window,
  },
  scrollbar = {
    function()
      local current_line = vim.fn.line "."
      local total_lines = vim.fn.line "$"
      local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = { fg = colors.blue },
    cond = nil,
  },
}

vim.cmd [[autocmd User LspProgressUpdate let &ro = &ro]]

M.config = {
  options = {
    icons_enabled = true,
    -- Disable sections and component separators
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = "auto",
    disabled_filetypes = { "dashboard", "alpha" },
    always_divide_middle = true,
    -- globalstatus = true,
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      -- components.left,
      components.mode1,
      components.branch,
      components.filetype,
      components.filename,
      components.diff,
      components.lsp_progress,
      "%=",
    },
    lualine_x = {
      components.diagnostics,
      components.lsp,
      -- components.treesitter,
      components.encoding,
      components.fileformat,
      components.spaces,
      components.filesize,
      components.clock,
      components.location,
      components.scrollbar,
    },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_c = { components.filename },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {
    {
      sections = {
        lualine_c = {
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
            end,
            color = { gui = "bold" },
          },
        },
      },
      filetypes = { "NvimTree", "neo-tree" },
    },
    {
      sections = {
        lualine_c = {
          {
            function()
              return "ToggleTerm #" .. vim.b.toggle_number
            end,
            color = { fg = colors.blue, gui = "bold" },
          },
        },
      },
      filetypes = { "toggleterm" },
    },
    {
      sections = { lualine_c = { { "filetype", color = { gui = "bold" } } } },
      filetypes = { "Outline", "SidebarNvim" },
    },
    {
      sections = {
        lualine_c = {
          {
            function()
              return "Sidebar"
            end,
            color = { gui = "bold" },
          },
        },
      },
      filetypes = { "SidebarNvim" },
    },
  },
}

M.setup = function()
  local lualine = require "lualine"
  lualine.setup(M.config)
end

return M
