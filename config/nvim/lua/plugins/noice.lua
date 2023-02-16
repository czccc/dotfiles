return {
  {
    "folke/noice.nvim",
    lazy = false,
    -- lazy = true,
    -- event = { "VeryLazy" },
    -- enabled = false,
    opts = {
      presets = {
        -- you can enable a preset by setting it to true, or a table that will override the preset config
        -- you can also add custom presets that you can enable/disable with enabled=true
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
        -- pcall(fu)
      },
      routes = {
        {
          view = "mini",
          filter = { event = "msg_showmode" },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        lazy = true,
        event = "VeryLazy",
        -- enabled = false,
        opts = {
          stages = "slide", ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
          timeout = 5000, ---@usage timeout for notifications in ms, default 5000
          render = "default", -- Render function for notifications. See notify-render()
          background_colour = "Normal", ---@usage highlight behind the window for stages that change opacity
          minimum_width = 50, ---@usage minimum width for notification windows
          icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "",
          },
        },
        config = function(_, opts)
          require("notify").setup(opts)
          require("telescope").load_extension("notify")
        end,
        keys = {
          { "<Leader>sn", "<cmd>Telescope notify<cr>", desc = "Notify" },
        },
        dependencies = { "nvim-telescope/telescope.nvim" },
      },
    },
  },
}
