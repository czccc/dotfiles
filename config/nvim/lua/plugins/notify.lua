return {
  "rcarriga/nvim-notify",
  lazy = true,
  event = "VeryLazy",
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
  config = function(spec, opts)
    require("notify").setup(opts)
    require("telescope").load_extension("notify")
  end,
  keys = {
    { "<Leader>sn", "<cmd>Telescope notify<cr>", desc = "Notify" },
  },
  dependencies = { "nvim-telescope/telescope.nvim" },
}
