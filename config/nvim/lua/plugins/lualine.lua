local globalstatus = vim.version().minor >= 7

local winwidth = function()
  if globalstatus then
    return vim.api.nvim_get_option("columns")
  else
    return vim.fn.winwidth(0)
  end
end

local conditions = {
  global_status = function()
    return vim.version().minor >= 7
  end,
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  wide_window = function()
    return winwidth() > 80
  end,
  large_window = function()
    return winwidth() > 150
  end,
  super_window = function()
    return winwidth() > 200
  end,
  check_git_workspace = function()
    -- local filepath = vim.fn.expand "%:p:h"
    local filepath = vim.fn.getcwd()
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir - 5 < #filepath
  end,
}

local colors = require("utils.colors")

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
      local map = {
        ["n"] = "NORMAL",
        ["no"] = "O-PENDING",
        ["nov"] = "O-PENDING",
        ["noV"] = "O-PENDING",
        ["no\22"] = "O-PENDING",
        ["niI"] = "NORMAL",
        ["niR"] = "NORMAL",
        ["niV"] = "NORMAL",
        ["nt"] = "NORMAL",
        ["v"] = "VISUAL",
        ["vs"] = "VISUAL",
        ["V"] = "V-LINE",
        ["Vs"] = "V-LINE",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK",
        ["s"] = "SELECT",
        ["S"] = "S-LINE",
        ["\19"] = "S-BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["ix"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rc"] = "REPLACE",
        ["Rx"] = "REPLACE",
        ["Rv"] = "V-REPLACE",
        ["Rvc"] = "V-REPLACE",
        ["Rvx"] = "V-REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "EX ",
        ["ce"] = "EX ",
        ["r"] = "REPLACE",
        ["rm"] = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
      }
      local mod = vim.fn.mode()
      if map[mod] == nil then
        return string.upper(mod)
      end
      return map[mod]:sub(1, 3)
    end,
    -- padding = { left = 0, right = 0 },
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
    padding = { left = 2, right = 1 },
  },
  branch = {
    "b:gitsigns_head",
    icon = " ",
    color = { fg = colors.blue, gui = "bold" },
    cond = function()
      return conditions.check_git_workspace() and conditions.large_window()
    end,
    padding = { left = 0, right = 1 },
  },
  branch1 = {
    "branch",
    icon = " ",
    color = { fg = colors.blue, gui = "bold" },
    cond = function()
      return conditions.check_git_workspace() and conditions.large_window()
    end,
    padding = { left = 0, right = 1 },
  },
  cwd = {
    function()
      local path_cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
      if #path_cwd > 30 then
        path_cwd = require("plenary.path"):new(path_cwd):shorten()
      end
      return path_cwd
    end,
    cond = conditions.super_window,
    color = { gui = "bold" },
    padding = { left = 1, right = 1 },
  },
  filename = {
    "filename",
    file_status = true, -- Displays file status (readonly status, modified status)
    path = 1,
    shorting_target = 150, -- Shortens path to leave 80 spaces in the window
    symbols = {
      modified = "[+]", -- Text to show when the file is modified.
      readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
      unnamed = "[No Name]", -- Text to show for unnamed buffers.
    },
    cond = conditions.buffer_not_empty,
    color = { gui = "bold" },
    padding = { left = 0, right = 1 },
  },
  filename1 = {
    function()
      local filepath = vim.fn.expand("%:~:.")
      if #filepath > 30 then
        filepath = require("plenary.path"):new(filepath):shorten()
      end
      if filepath == "" then
        filepath = "[No Name]"
      end
      if vim.bo.modified then
        filepath = filepath .. "[+]"
      end
      if vim.bo.modifiable == false or vim.bo.readonly == true then
        filepath = filepath .. "[-]"
      end
      return filepath
    end,
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
    padding = { left = 1, right = 1 },
    cond = nil,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    cond = nil,
    -- cond = conditions.wide_window,
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
  testing = {
    function()
      if vim.fn["ultest#is_test_file"]() == 1 then
        local t = ""
        local s = vim.fn["ultest#status"]()
        if s.tests > 0 then
          t = t .. "  " .. s.tests
        end
        if s.passed > 0 then
          t = t .. "  " .. s.passed
        end
        if s.failed > 0 then
          t = t .. "  " .. s.failed
        end
        if s.running > 0 then
          t = t .. "  " .. s.running
        end
        return t
      end
      return ""
    end,
    color = { gui = "bold", fg = colors.green },
    cond = conditions.large_window,
  },
  testing1 = {
    "diff",
    source = function()
      local s = vim.fn["ultest#status"]()
      return { added = s.tests, modified = s.passed, removed = s.failed }
    end,
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    cond = vim.fn["ultest#is_test_file"],
  },
  lsp = {
    function()
      local buf_client_names = {}

      local b = vim.api.nvim_get_current_buf()
      if next(vim.treesitter.highlighter.active[b]) then
        table.insert(buf_client_names, "")
      end
      -- add client
      local buf_clients = vim.lsp.get_active_clients()
      if #buf_clients > 0 then
        table.insert(buf_client_names, "ﲀ")
      end

      return table.concat(buf_client_names, " ")
    end,
    color = { gui = "bold", fg = colors.green },
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
  navic = {
    function()
      local status_ok, navic = pcall(require, "nvim-navic")
      if not status_ok then
        return ""
      end
      if not navic.is_available() then
        return ""
      end
      return navic.get_location()
    end,
  },
  location = {
    "location",
    -- cond = conditions.wide_window,
    color = { fg = colors.yellow },
  },
  progress = {
    "progress",
    cond = conditions.wide_window,
  },
  spaces = {
    function()
      if not vim.api.nvim_buf_get_option(0, "expandtab") then
        if not conditions.large_window() then
          return "T: " .. vim.api.nvim_buf_get_option(0, "tabstop")
        end
        return "Tab: " .. vim.api.nvim_buf_get_option(0, "tabstop")
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
    color = { fg = colors.green },
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
    color = { fg = colors.orange },
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

      local file = vim.fn.expand("%:p")
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
      -- return " " .. os.date("%H:%M")
      return require("utils.tomato").get_time()
    end,
    color = { fg = colors.purple },
    cond = conditions.large_window,
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
      local current_line = vim.fn.line(".")
      local total_lines = vim.fn.line("$")
      local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = { fg = colors.blue },
  },
  recording = {
    function()
      return require("noice").api.status.mode.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.mode.has()
    end,
    color = { fg = colors.orange },
  },
  keymap = {
    function()
      return require("noice").api.status.command.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.command.has()
    end,
    color = { fg = colors.green },
  },
  updates = {
    require("lazy.status").updates,
    cond = require("lazy.status").has_updates,
    color = { fg = colors.orange },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    event = "VimEnter",
    -- dependencies = {
    --   "folke/noice.nvim",
    -- },
    opts = {
      options = {
        icons_enabled = true,
        -- Disable sections and component separators
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        theme = "auto",
        disabled_filetypes = { "dashboard", "alpha" },
        always_divide_middle = true,
        globalstatus = globalstatus,
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {
          -- components.left,
          -- components.mode1,
          components.mode,
        },
        lualine_b = {
          components.cwd,
          -- components.branch,
          components.branch1,
          components.filetype,
          components.filename1,
        },
        lualine_c = {
          components.diff,
          -- components.navic,
          -- components.lsp_progress,
          "%=",
        },
        lualine_x = {
          components.recording,
          components.keymap,
          components.updates,

          components.diagnostics,
          components.testing,
          -- components.testing1,
          components.lsp,
          -- components.treesitter,
          components.filesize,
          components.spaces,
          components.encoding,
          components.fileformat,
          -- components.clock,
          components.location,
          components.scrollbar,
        },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
