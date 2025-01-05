return {
  { "folke/edgy.nvim", opts = { wo = { winhighlight = "" } } },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Main options --
      style = "cool", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false, -- Show/hide background
      term_colors = true, -- Change terminal color as per the selected theme style
      ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
      -- toggle theme style ---
      toggle_style_key = "<NOP>", -- Default keybinding to toggle
      -- toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

      -- Change code style ---
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
      code_style = {
        comments = "none",
        keywords = "bold",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Custom Highlights --
      colors = {
        -- bg0 = "#282c34",
      }, -- Override default colors
      highlights = {
        -- StatusLine = { bg = "$bg1" },
        -- SignColumn = { bg = "none" },
        -- StatusLineNC = { bg = "#2d3343" },
        -- Visual = { bg = "#404859" },
        -- Visual = { bg = "$bg3" },
        -- Search = { fg = "none", bg = "$bg3" },
        -- CursorLineNr = { fg = "$yellow", fmt = "bold" },

        -- VertSplit = { fg = "$bg0" },
        -- WinSeparator = { fg = "$bg1", fmt = "bold" },
        -- NeoTreeVertSplit = { fg = "$bg1", fmt = "bold" },
        -- NvimTreeWinSeparator = { fg = "$bg1", fmt = "bold" },
        NeoTreeWinSeparator = { fg = "$bg2", bg = "$bg0", fmt = "bold" },

        BufferLineFill = { bg = "$bg0" },
        -- LazyNormal = { bg = "$bg0" },

        WinBar = { bg = "$bg0" },
        WinBarNC = { bg = "$bg0" },

        ["@field"] = { fg = "$red" },
        ["@operator"] = { fg = "$purple" },
        ["@variable"] = { fg = "$red" },
        ["@variable.builtin"] = { fg = "$yellow" },
        ["@property"] = { fg = "$red" },
        ["@function.macro"] = { fg = "$orange" },
        ["@function.builtin"] = { fg = "$orange" },
        ["@keyword.function"] = { fmt = "bold" },

        ["@lsp.type.variable"] = { fg = "$red" },
        ["@lsp.type.property"] = { fg = "$red" },
        ["@lsp.type.macro"] = { fg = "$orange" },

        cppTSConstant = { fg = "$orange" },
        cTSConstant = { fg = "$orange" },
        TSPunctBracket = { fg = "$purple" },

        CmpItemAbbrMatch = { fg = "$green" },
        CmpItemAbbrMatchFuzzy = { fg = "$green" },

        HlSearchLens = { bg = "$bg3" },

        rainbowcol1 = { fg = "$purple" },

        TreesitterContextLineNumber = { bg = "$bg2", fg = "$yellow", fmt = "bold" },
        TreesitterContext = { bg = "$bg2" },

        IlluminatedWordText = { bg = "$bg2", fmt = "none" },
        IlluminatedWordRead = { bg = "$bg2", fmt = "none" },
        IlluminatedWordWrite = { bg = "$bg2", fmt = "none" },

        IndentBlankLineContextChar = { fg = "$blue" },
        MiniIndentscopeSymbol = { fg = "$blue" },
      }, -- Override highlight groups

      -- Plugins Config --
      diagnostics = {
        darker = false, -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = false, -- use background color for virtual text
      },
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      -- load the colorscheme here
      vim.cmd.colorscheme("onedark")
    end,
  },
}
