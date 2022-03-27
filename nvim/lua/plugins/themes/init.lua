local M = {}

M.config = function()
  gconf.colorscheme = "tokyonight"
end

M.packers = {
  {
    "Mofiqul/vscode.nvim",
    opt = true,
    config = function()
      vim.g.vscode_style = "dark"
    end,
  },
  {
    "shaunsingh/nord.nvim",
    opt = true,
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
    opt = true,
    config = function()
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
    end,
  },
  -- { "LunarVim/onedarker.nvim" },
  {
    "navarasu/onedark.nvim",
    opt = true,
    config = function()
      require("onedark").setup {
        -- Main options --
        style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = false, -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        -- toggle theme style ---
        toggle_style_key = "<leader>ts", -- Default keybinding to toggle
        toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
          variables = "none",
        },

        -- Custom Highlights --
        colors = {}, -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true, -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
    end,
  },
  {
    "NTBBloodbath/doom-one.nvim",
    opt = true,
    config = function()
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
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    opt = true,
    config = function()
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
  vim.g.tokyonight_colors = { NvimTreeGitDirty = "orange" }
end

return M
