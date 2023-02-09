local utils = require("utils")

return {
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
    },
    init = function()
      utils.keymap.group("n", "<Leder>t", "Terminal/Test")
    end,
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",

            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- is_test_file = function(file_path)
            --   ...
            -- end,
          }),
          require("neotest-go"),
          require("neotest-plenary"),
          require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua" },
            allow_file_types = { "haskell", "elixir" },
          }),
        },
        summary = {
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
          },
        },
      })
    end,
    keys = {
      {
        "[t",
        function()
          require("neotest").jump.prev()
        end,
        desc = "Previous Test",
      },
      {
        "]t",
        function()
          require("neotest").jump.next()
        end,
        desc = "Next Test",
      },
      {
        "[T",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Previous Failed Test",
      },
      {
        "]T",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next Failed Test",
      },
      {
        "<Leadet>tu",
        function()
          require("neotest").summary.open()
        end,
        desc = "Test Summary",
      },
      {
        "<Leadet>to",
        function()
          require("neotest").output.open({ enter = false })
        end,
        desc = "Test Output",
      },
      {
        "<Leadet>tl",
        function()
          require("neotest").summary.open()
        end,
        desc = "Test ",
      },
      {
        "<Leadet>tu",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test Last",
      },
      {
        "<Leadet>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Test Nearest",
      },
      {
        "<Leadet>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test File",
      },
      {
        "<Leadet>ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test Stop",
      },
    },
  },
}
