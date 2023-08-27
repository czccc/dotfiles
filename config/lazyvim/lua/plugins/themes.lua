return {
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
      style = "cool",                                                                      -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false,                                                                 -- Show/hide background
      term_colors = false,                                                                 -- Change terminal color as per the selected theme style
      ending_tildes = false,                                                               -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false,                                                        -- reverse item kind highlights in cmp menu
      -- toggle theme style ---
      toggle_style_key = "<NOP>",                                                          -- Default keybinding to toggle
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
      colors = {
        -- bg0 = "#282c34",
      }, -- Override default colors
      highlights = {
        -- StatusLine = { bg = "$bg1" },
        SignColumn = { bg = "none" },
        -- StatusLineNC = { bg = "#2d3343" },
        -- Visual = { bg = "#404859" },
        Visual = { bg = "$bg3" },
        -- Search = { fg = "none", bg = "$bg3" },
        CursorLineNr = { fg = "$yellow", fmt = "bold" },

        ["@field"] = { fg = "$red" },
        ["@operator"] = { fg = "$purple" },
        ["@variable"] = { fg = "$red" },
        ["@variable.builtin"] = { fg = "$yellow" },
        ["@property"] = { fg = "$red" },
        ["@function.macro"] = { fg = "$orange" },
        ["@function.builtin"] = { fg = "$orange" },
        ["@keyword.function"] = { fmt = "bold" },
        cppTSConstant = { fg = "$orange" },
        cTSConstant = { fg = "$orange" },
        TSPunctBracket = { fg = "$purple" },

        packerStatusSuccess = { fg = "$green" },

        CmpItemAbbrMatch = { fg = "$green" },
        CmpItemAbbrMatchFuzzy = { fg = "$green" },

        OperatorSandwichChange = { fg = "$bg0", bg = "$orange" },
        OperatorSandwichDelete = { fg = "$bg0", bg = "$orange" },
        OperatorSandwichAdd = { fg = "$bg0", bg = "$orange" },

        HlSearchLens = { bg = "$bg3" },

        NeoTreeVertSplit = { fg = "$bg0", bg = "$bg_d" },
        NeoTreeWinSeparator = { fg = "$bg_d", bg = "$bg_d" },

        rainbowcol1 = { fg = "$purple" },

        HopNextKey = { fg = "$bg0", bg = "$orange", fmt = "none" },
        HopNextKey1 = { fg = "$bg0", bg = "$blue", fmt = "none" },
        HopNextKey2 = { fg = "$yellow", fmt = "bold" },
        HopUnmatched = { fg = "$grey" },

        LightspeedLabel = { fg = "$yellow", fmt = "bold,underline" },
        LightspeedShortcut = { fg = "$black", bg = "$blue", fmt = "bold" },
        LightspeedLabelDistant = { fg = "$blue", fmt = "bold,underline" },
        LightspeedUnlabeledMatch = { fg = "$black", bg = "$yellow", fmt = "bold" },
        LightspeedMaskedChar = { fg = "$purple", fmt = "bold" },
        LightspeedGreyWash = { fg = "$grey" },

        TreesitterContextLineNumber = { bg = "$bg2", fg = "$yellow", fmt = "bold" },
        TreesitterContext = { bg = "$bg2" },

        IlluminatedWordText = { fmt = "none" },
        IlluminatedWordRead = { fmt = "none" },
        IlluminatedWordWrite = { fmt = "none" },

        BufferLineFill = { bg = "$bg0" },

        IndentBlankLineContextChar = { fg = "$blue" },
      }, -- Override highlight groups

      -- Plugins Config --
      diagnostics = {
        darker = false,     -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = false, -- use background color for virtual text
      },
    },
    config = function(spec, opts)
      require("onedark").setup(opts)
      -- load the colorscheme here
      vim.cmd.colorscheme("onedark")
    end,
  },
}
