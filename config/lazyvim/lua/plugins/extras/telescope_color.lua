return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
      pickers = {
        buffers = { theme = "dropdown", borderchars = { " ", " ", " ", " ", " ", " ", " ", " " } },
        command_history = { theme = "dropdown", borderchars = { " ", " ", " ", " ", " ", " ", " ", " " } },
        live_grep = { theme = "ivy", borderchars = { " ", " ", " ", " ", " ", " ", " ", " " } },
        grep_string = { theme = "ivy", borderchars = { " ", " ", " ", " ", " ", " ", " ", " " } },
      },
    },
  },
  {
    "navarasu/onedark.nvim",
    opts = {
      highlights = {
        -- telescope
        TelescopeSelection = { bg = "$bg3" },
        TelescopeNormal = { fg = "$cyan", bg = "$bg_d" },
        TelescopePromptNormal = { bg = "$black" },
        TelescopePromptBorder = { fg = "$black", bg = "$black" },
        TelescopePromptTitle = { fg = "$bg_d", bg = "$orange", fmt = "bold" },
        TelescopeResultsNormal = { bg = "$bg_d" },
        TelescopeResultsBorder = { fg = "$bg_d", bg = "$bg_d" },
        TelescopeResultsTitle = { fg = "$bg_d", bg = "$orange", fmt = "bold" },
        TelescopePreviewNormal = { bg = "$bg_d" },
        TelescopePreviewBorder = { fg = "$bg_d", bg = "$bg_d" },
        TelescopePreviewTitle = { fg = "$bg_d", bg = "$orange", fmt = "bold" },
      },
    },
  },
}
