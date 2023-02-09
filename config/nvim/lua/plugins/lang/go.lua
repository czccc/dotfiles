return {
  {
    "ray-x/go.nvim",
    ft = { "go" },
    opt = true,
    dependencies = {
      "ray-x/guihua.lua",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local go = require("go")

      ---@diagnostic disable-next-line: redundant-parameter
      go.setup({
        go = "go", -- go command, can be go[default] or go1.18beta1
        goimport = "gopls", -- goimport command, can be gopls[default] or goimport
        fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
        gofmt = "gofumpt", --gofmt cmd,
        max_line_len = 120, -- max line length in goline format
        tag_transform = false, -- tag_transfer  check gomodifytags for details
        test_template = "", -- g:go_nvim_tests_template  check gotests for details
        test_template_dir = "", -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
        comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
        icons = { breakpoint = "🧘", currentpos = "🏃" }, -- setup to `false` to disable icons setup
        verbose = false, -- output loginf in messages
        lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
        lsp_on_attach = function(client, bufnr)
          require("utils.lsp").common_on_attach(client, bufnr)
          -- utils.load_wk({
          --   name = "Module",
          --   F = { "<cmd>GoFmt<cr>", "GoFmt" },
          --   s = { "<cmd>GoFillStruct<cr>", "GoFillStruct" },
          --   S = { "<cmd>GoFillSwitch<cr>", "GoFillSwitch" },
          --   e = { "<cmd>GoIfErr<cr>", "GoIfErr" },
          --   m = { "<cmd>GoMake<cr>", "GoMake" },
          --   b = { "<cmd>GoBuild<cr>", "GoBuild" },
          --   g = { "<cmd>GoGenerate<cr>", "GoGenerate" },
          --   r = { "<cmd>GoRun<cr>", "GoRun" },
          --   v = { "<cmd>GoVet<cr>", "GoVet" },
          --   C = { "<cmd>GoCoverage<cr>", "GoCoverage" },
          --   T = { "<cmd>GoTest<cr>", "GoTest" },
          --   p = { "<cmd>GoTestPkg<cr>", "GoTestPkg" },
          --   t = { "<cmd>GoTestFunc<cr>", "GoTestFunc" },
          --   f = { "<cmd>GoTestFile<cr>", "GoTestFile" },
          --   d = { "<cmd>GoDoc<cr>", "GoDoc" },
          --   D = { "<cmd>GoDebug<cr>", "GoDebug" },
          --   a = { "<cmd>GoCodeAction<cr>", "GoCodeAction" },
          --   c = { "<cmd>GoCmt<cr>", "GoCmt " },
          -- }, { prefix = "<Leader>m", mode = "n", opts = { buffer = bufnr } })
        end, -- nil: use on_attach function defined in go/lsp.lua,
        --      when lsp_cfg is true
        -- if lsp_on_attach is a function: use this function as on_attach function for gopls
        lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
        lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
        -- function(bufnr)
        --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
        -- end
        -- to setup a table of codelens
        lsp_diag_hdlr = true, -- hook lsp diag handler
        -- virtual text setup
        lsp_diag_virtual_text = { space = 0, prefix = "" },
        lsp_diag_signs = true,
        lsp_diag_update_in_insert = false,
        lsp_document_formatting = true,
        -- set to true: use gopls to format
        -- false if you want to use other formatter tool(e.g. efm, nulls)
        gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
        gopls_remote_auto = true, -- add -remote=auto to gopls
        dap_debug = true, -- set to false to disable dap
        dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
        -- false: do not use keymap in go/dap.lua.  you must define your own.
        dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
        dap_debug_vt = true, -- set to true to enable dap virtual text
        build_tags = nil, -- set default build tags
        textobjects = true, -- enable default text jobects through treesittter-text-objects
        test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
        run_in_floaterm = false, -- set to true to run in float window.
        --float term recommand if you use richgo/ginkgo with terminal color
        lsp_cfg = {
          -- true: use non-default gopls setup specified in go/lsp.lua
          -- false: do nothing
          -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
          --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
          -- other setups
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
              experimentalWatchedFileDelay = "100ms",
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
        },
      })
    end,
  },
}
