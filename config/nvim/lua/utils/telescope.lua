local fn = require("utils.fn")

local M = {}

local function dropdown_opts(opts)
  opts = opts or {}
  local theme_opts = {
    theme = "dropdown",
    results_title = false,
    winblend = 15,
    shorten_path = false,
    previewer = false,
    sorting_strategy = "ascending",
    layout_strategy = "center",
    layout_config = {
      prompt_position = "top",
      width = function(_, max_columns, _)
        return math.min(max_columns, 80)
      end,
      height = function(_, _, max_lines)
        return math.min(max_lines, 15)
      end,
    },
    border = true,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end
M.dropdown_opts = dropdown_opts

local function ivy_opts(opts)
  opts = opts or {}
  local theme_opts = {
    theme = "ivy",
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    ignore_filename = false,
    layout_config = { height = 25 },
    border = true,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end
M.ivy_opts = ivy_opts

M.builtin = function(builtin, opts)
  opts = opts or {}
  return function()
    require("telescope.builtin")[builtin](opts)
  end
end

M.ivy = function(builtin, opts)
  opts = ivy_opts(opts)
  return M.builtin(builtin, opts)
end

M.dropdown = function(builtin, opts)
  opts = dropdown_opts(opts)
  return M.builtin(builtin, opts)
end

M.find_files = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.loop.cwd()
  local builtin = "find_files"
  if vim.loop.fs_stat(fn.join(opts.cwd, ".git")) then
    opts.show_untracked = true
    builtin = "git_files"
  end
  return M.builtin(builtin, opts)
end

function M.search_only_certain_files()
  require("telescope.builtin").find_files({
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input({ prompt = "Type: " }),
    },
  })
end

function M.curbuf_grep_visual_string()
  local opts = ivy_opts()
  opts.default_text = fn.visual_selection()
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

return M
