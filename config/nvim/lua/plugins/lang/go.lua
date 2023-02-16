return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "ray-x/go.nvim",
      build = ':lua require("go.install").update_all_sync()',
      dependencies = {
        "ray-x/guihua.lua",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    opts = {
      servers = {
        gopls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            gopls = {
              -- gofumpt = true, -- A stricter gofmt
              codelenses = {
                gc_details = true, -- Toggle the calculation of gc annotations
                generate = true, -- Runs go generate for a given directory
                regenerate_cgo = true, -- Regenerates cgo definitions
                tidy = true, -- Runs go mod tidy for a module
                upgrade_dependency = true, -- Upgrades a dependency in the go.mod file for a module
                vendor = true, -- Runs go mod vendor for a module
              },
              diagnosticsDelay = "300ms",
              symbolMatcher = "fuzzy",
              completeUnimported = true,
              staticcheck = true,
              matcher = "Fuzzy",
              usePlaceholders = true, -- enables placeholders for function parameters or struct fields in completion responses
              analyses = {
                -- fieldalignment = true, -- find structs that would use less memory if their fields were sorted
                nilness = true, -- check for redundant or impossible nil comparisons
                shadow = true, -- check for possible unintended shadowing of variables
                unusedparams = true, -- check for unused parameters of functions
                unusedwrite = true, -- checks for unused writes, an instances of writes to struct fields and arrays that are never read
              },
            },
          },
          on_attach = function(client, buffer)
            local utils = require("utils")
            utils.keymap.set("n", "<Leader>mF", "<cmd>GoFmt<cr>", { desc = "GoFmt", buffer = buffer })
            utils.keymap.set("n", "<Leader>ms", "<cmd>GoFillStruct<cr>", { desc = "GoFillStruct", buffer = buffer })
            utils.keymap.set("n", "<Leader>mS", "<cmd>GoFillSwitch<cr>", { desc = "GoFillSwitch", buffer = buffer })
            utils.keymap.set("n", "<Leader>me", "<cmd>GoIfErr<cr>", { desc = "GoIfErr", buffer = buffer })
            utils.keymap.set("n", "<Leader>mm", "<cmd>GoMake<cr>", { desc = "GoMake", buffer = buffer })
            utils.keymap.set("n", "<Leader>mb", "<cmd>GoBuild<cr>", { desc = "GoBuild", buffer = buffer })
            utils.keymap.set("n", "<Leader>mg", "<cmd>GoGenerate<cr>", { desc = "GoGenerate", buffer = buffer })
            utils.keymap.set("n", "<Leader>mr", "<cmd>GoRun<cr>", { desc = "GoRun", buffer = buffer })
            utils.keymap.set("n", "<Leader>mv", "<cmd>GoVet<cr>", { desc = "GoVet", buffer = buffer })
            utils.keymap.set("n", "<Leader>mC", "<cmd>GoCoverage<cr>", { desc = "GoCoverage", buffer = buffer })
            utils.keymap.set("n", "<Leader>mT", "<cmd>GoTest<cr>", { desc = "GoTest", buffer = buffer })
            utils.keymap.set("n", "<Leader>mp", "<cmd>GoTestPkg<cr>", { desc = "GoTestPkg", buffer = buffer })
            utils.keymap.set("n", "<Leader>mt", "<cmd>GoTestFunc<cr>", { desc = "GoTestFunc", buffer = buffer })
            utils.keymap.set("n", "<Leader>mf", "<cmd>GoTestFile<cr>", { desc = "GoTestFile", buffer = buffer })
            utils.keymap.set("n", "<Leader>md", "<cmd>GoDoc<cr>", { desc = "GoDoc", buffer = buffer })
            utils.keymap.set("n", "<Leader>mD", "<cmd>GoDebug<cr>", { desc = "GoDebug", buffer = buffer })
            utils.keymap.set("n", "<Leader>ma", "<cmd>GoCodeAction<cr>", { desc = "GoCodeAction", buffer = buffer })
            utils.keymap.set("n", "<Leader>mc", "<cmd>GoCmt<cr>", { desc = "GoCmt", buffer = buffer })
          end,
        },
      },
      setup = {
        gopls = function()
          require("go").setup({})
        end,
      },
    },
  },
}
