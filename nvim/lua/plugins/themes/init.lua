local M = {}

M.init = function()
  require("core.colors").colorscheme = "onedark"
end

M.packers = {
  {
    "Mofiqul/vscode.nvim",
    -- opt = true,
    config = function()
      vim.g.vscode_style = "dark"
    end,
  },
  {
    "folke/tokyonight.nvim",
    -- opt = true,
    config = function()
      require("plugins.themes").setup_tokyonight()
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    -- opt = true,
    config = function()
      require("plugins.themes").setup_kanagawa()
    end,
  },
  { "LunarVim/onedarker.nvim" },
  {
    "navarasu/onedark.nvim",
    -- opt = true,
    config = function()
      require("plugins.themes").setup_onedark()
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    -- opt = true,
    config = function()
      require("plugins.themes").setup_onedark_pro()
    end,
  },
  {
    "NTBBloodbath/doom-one.nvim",
    -- opt = true,
    config = function()
      require("plugins.themes").setup_doom_one()
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    -- opt = true,
    config = function()
      require("plugins.themes").setup_nightfox()
    end,
  },
}

M.setup_tokyonight = function()
  vim.g.tokyonight_dev = true
  vim.g.tokyonight_style = "storm"
  vim.g.tokyonight_sidebars = {
    "qf",
    "vista_kind",
    "terminal",
    "packer",
    "spectre_panel",
    "NeogitStatus",
    "help",
    "Outline",
  }
  vim.g.tokyonight_cterm_colors = false
  vim.g.tokyonight_terminal_colors = true
  vim.g.tokyonight_italic_comments = true
  vim.g.tokyonight_italic_keywords = true
  vim.g.tokyonight_italic_functions = false
  vim.g.tokyonight_italic_variables = false
  vim.g.tokyonight_hide_inactive_statusline = true
  vim.g.tokyonight_dark_sidebar = true
  vim.g.tokyonight_dark_float = true
  vim.g.tokyonight_colors = {
    -- NvimTreeGitDirty = "orange",
    -- FocusedSymbol = "Visual",
  }
end

M.setup_kanagawa = function()
  require("kanagawa").setup {
    undercurl = true, -- enable undercurls
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    globalStatus = false, -- adjust window separators highlight for laststatus=3
    colors = {},
    overrides = {},
  }
end

M.setup_onedark = function()
  require("onedark").setup {
    -- Main options --
    style = "cool", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false, -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    -- toggle theme style ---
    toggle_style_key = "<NOP>", -- Default keybinding to toggle
    -- toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between
    toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
    code_style = {
      comments = "italic",
      keywords = "bold",
      functions = "none",
      strings = "none",
      variables = "none",
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {
      StatusLine = { bg = "$bg1" },
      SignColumn = { bg = "none" },
      -- StatusLineNC = { bg = "#2d3343" },
      Visual = { bg = "#404859" },
      -- Visual = { bg = "$bg3" },
      TSField = { fg = "$red" },
      TSOperator = { fg = "$purple" },
      TSVariable = { fg = "$red" },
      TSProperty = { fg = "$red" },
      TSFuncMacro = { fg = "$orange" },
      TSFuncBuiltin = { fg = "$orange" },
      TSConstant = { fg = "$orange" },
      packerStatusSuccess = { fg = "$green" },
    }, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
      darker = false, -- darker colors for diagnostic
      undercurl = true, -- use undercurl instead of underline for diagnostics
      background = false, -- use background color for virtual text
    },
  }
  -- require("onedark").load()
  local cl = require "core.colors"
  cl.define_links("LspReferenceText", "Visual")
  cl.define_links("LspReferenceRead", "Visual")
  cl.define_links("LspReferenceWrite", "Visual")
  cl.define_links("FocusedSymbol", "Visual")
  cl.define_links("Search", "Visual")
  cl.define_links("OperatorSandwichChange", "IncSearch")
  cl.define_links("OperatorSandwichDelete", "IncSearch")
  cl.define_links("OperatorSandwichAdd", "IncSearch")
  cl.setup_colorscheme()
end

M.setup_onedark_pro = function()
  vim.o.background = "dark"
  require("onedarkpro").setup {
    -- Theme can be overwritten with 'onedark' or 'onelight' as a string
    theme = function()
      if vim.o.background == "dark" then
        return "onedark"
      else
        return "onelight"
      end
    end,
    colors = {}, -- Override default colors by specifying colors for 'onelight' or 'onedark' themes
    hlgroups = {
      StatusLine = { bg = "#33373e" },
      StatusLineNC = { bg = "#33373e" },
    }, -- Override default highlight groups
    filetype_hlgroups = {}, -- Override default highlight groups for specific filetypes
    plugins = { -- Override which plugins highlight groups are loaded
      native_lsp = true,
      polygot = true,
      treesitter = true,
      -- NOTE: Other plugins have been omitted for brevity
    },
    styles = {
      strings = "NONE", -- Style that is applied to strings
      comments = "NONE", -- Style that is applied to comments
      keywords = "NONE", -- Style that is applied to keywords
      functions = "NONE", -- Style that is applied to functions
      variables = "NONE", -- Style that is applied to variables
    },
    options = {
      bold = true, -- Use the themes opinionated bold styles?
      italic = true, -- Use the themes opinionated italic styles?
      underline = false, -- Use the themes opinionated underline styles?
      undercurl = false, -- Use the themes opinionated undercurl styles?
      cursorline = true, -- Use cursorline highlighting?
      transparency = false, -- Use a transparent background?
      terminal_colors = false, -- Use the theme's colors for Neovim's :terminal?
      window_unfocussed_color = true, -- When the window is out of focus, change the normal background?
    },
  }
  -- require("onedarkpro").load()
  local cl = require "core.colors"
  cl.define_links("LspReferenceText", "Visual")
  cl.define_links("LspReferenceRead", "Visual")
  cl.define_links("LspReferenceWrite", "Visual")
  cl.define_links("FocusedSymbol", "Visual")
  cl.setup_colorscheme()
end

M.setup_doom_one = function()
  require("doom-one").setup {
    cursor_coloring = false,
    terminal_colors = false,
    italic_comments = false,
    enable_treesitter = true,
    transparent_background = false,
    pumblend = {
      enable = true,
      transparency_amount = 20,
    },
    plugins_integrations = {
      neorg = true,
      barbar = true,
      bufferline = false,
      gitgutter = false,
      gitsigns = true,
      telescope = false,
      neogit = true,
      nvim_tree = true,
      dashboard = true,
      startify = true,
      whichkey = true,
      indent_blankline = true,
      vim_illuminate = true,
      lspsaga = false,
    },
  }
end

M.setup_nightfox = function()
  require("nightfox").setup {
    options = {
      -- Compiled file's destination location
      compile_path = vim.fn.stdpath "cache" .. "/nightfox",
      compile_file_suffix = "_compiled", -- Compiled file suffix
      transparent = false, -- Disable setting background
      terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
      dim_inactive = false, -- Non focused panes set to alternative background
      styles = { -- Style to be applied to different syntax groups
        comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
        functions = "NONE",
        keywords = "NONE",
        numbers = "NONE",
        strings = "NONE",
        types = "NONE",
        variables = "NONE",
      },
      inverse = { -- Inverse highlight for different types
        match_paren = false,
        visual = false,
        search = false,
      },
      modules = { -- List of various plugins and additional options
        -- ...
      },
    },
  }
end

return M
