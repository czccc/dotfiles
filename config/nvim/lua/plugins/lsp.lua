local utils = require("utils")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufReadPost",
    opts = {
      diagnostics = {
        signs = {
          active = true,
          values = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
          },
        },
        virtual_text = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          format = function(d)
            local t = vim.deepcopy(d)
            local code = d.code or (d.user_data and d.user_data.lsp.code)
            if code then
              t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
            end
            return t.message
          end,
        },
      },
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
      },
    },
    init = function()
      utils.keymap.group("n", "<Leader>l", "LSP")
    end,
    config = function(spec, opts)
      local lspconfig = require("lspconfig")
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = utils.lsp.common_capabilities(),
        on_attach = utils.lsp.common_on_attach,
      })
      for _, sign in ipairs(opts.diagnostics.signs.values) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
      end

      vim.diagnostic.config(opts.diagnostics)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, opts.float)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, opts.float)

      lspconfig.taplo.setup({})
      lspconfig.volar.setup({})
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            hover = true,
            completion = true,
            validate = true,
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
              kubernetes = {
                "daemon.{yml,yaml}",
                "manager.{yml,yaml}",
                "restapi.{yml,yaml}",
                "role.{yml,yaml}",
                "role_binding.{yml,yaml}",
                "*onfigma*.{yml,yaml}",
                "*ngres*.{yml,yaml}",
                "*ecre*.{yml,yaml}",
                "*eployment*.{yml,yaml}",
                "*ervic*.{yml,yaml}",
                "kubectl-edit*.yaml",
              },
            },
          },
        },
      })
    end,
    keys = {
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous Diagnostic" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
      { "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous Diagnostic" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
      -- { "[od", enable_cursor_diagnostic, desc = "Cursor Diagnostic" },
      -- { "]od", disable_cursor_diagnostic, desc = "Cursor Diagnostic" },

      { "ga", vim.lsp.buf.range_code_action, mode = "v", desc = "Code Actions" },
      { "gF", vim.lsp.buf.range_formatting, mode = "v", desc = "Format Code" },
      { "gF", utils.lsp.format, desc = "Format Code" },
      { "gL", vim.lsp.codelens.run, desc = "Code Lens" },
      { "gh", vim.lsp.buf.signature_help, desc = "Show Signature Help" },

      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Show Hover" },
      { "gp", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Finder" },
      { "gr", "<cmd>Lspsaga rename<cr>", desc = "Rename Symbol" },
      { "ga", "<cmd>Lspsaga code_action<CR>", desc = "Code Actions" },
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Goto Definition" },
      { "gD", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },

      { "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Line Diagnostics" },
      { "gB", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Show Line Diagnostics" },
      { "gC", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Show Line Diagnostics" },

      { "<Leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "<Leader>lR", "<cmd>LspRestart<cr>", desc = "Lsp Restart" },
      { "<Leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Lsp Outline" },

      { "<Leader>ls", utils.telescope.builtin("lsp_document_symbols"), desc = "Document Symbols" },
      { "<Leader>lS", utils.telescope.builtin("lsp_dynamic_workspace_symbols"), desc = "Workspace Symbols" },
      { "<Leader>ld", utils.telescope.ivy("diagnostics", { bufnr = 0 }), desc = "Buffer Diagnostic" },
      { "<Leader>lD", utils.telescope.builtin("diagnostics"), desc = "Workspace Diagnostic" },
      { "<Leader>lr", utils.telescope.builtin("lsp_references"), desc = "LSP Reference" },
      { "<Leader>lO", utils.telescope.builtin("lsp_implementations"), desc = "LSP Implementations" },
    },
    dependencies = {
      "hrsh7th/nvim-cmp",
      {
        "glepnir/lspsaga.nvim",
        lazy = true,
        cmd = { "Lspsaga" },
        event = "BufReadPost",
        config = function()
          require("lspsaga").setup({
            preview = { lines_above = 2, lines_below = 10 },
            scroll_preview = { scroll_down = "<C-d>", scroll_up = "<C-u>" },
            ui = {
              -- Border type can be single, double, rounded, solid, shadow.
              border = "rounded",
              winblend = 0,
              code_action = " ",
              custom_fix = " Fix",
            },
            finder = {
              max_height = 0.8,
              keys = { jump_to = "p", vsplit = "s", split = "S" },
            },
            code_action = {
              show_server_name = true,
              keys = {
                quit = { "q", "<Esc>" },
                exec = "<CR>",
              },
            },
            lightbulb = { sign = true, virtual_text = true },
            diagnostic = {
              max_width = 0.7,
              text_hl_follow = false,
              border_follow = true,
              keys = {
                exec_action = "<CR>",
                quit = "<Esc>",
                go_action = "g",
              },
            },
            rename = {
              quit = "<Esc>",
              exec = "<CR>",
              mark = "x",
              confirm = "<CR>",
              in_select = true,
            },
          })
        end,
        dependencies = { { "kyazdani42/nvim-web-devicons" } },
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    lazy = true,
    event = { "BufRead", "BufNew" },
    config = function()
      require("lsp_signature").setup({
        bind = true,
        floating_window = true,
        floating_window_above_cur_line = true,
        hint_enable = true,
        -- hint_prefix = "🐼 ",
        hint_prefix = " ",
        hint_scheme = "String",
        hi_parameter = "Search",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    event = "BufReadPost",
    keys = {
      { "<Leader>uI", "<cmd>NullLsInfo<cr>", desc = "NullLs Info" },
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        on_attach = require("utils.lsp").common_on_attach,
        capabilities = require("utils.lsp").common_capabilities(),
        sources = {
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = "BufReadPost",
    cmd = { "Mason" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    keys = {
      { "<Leader>lI", "<cmd>Mason<cr>", desc = "Installer" },
    },
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    event = "BufReadPost",
    opts = {
      ensure_installed = { "sumneko_lua", "pyright", "yamlls" },
      automatic_installation = true,
    },
    dependencies = { "neovim/nvim-lspconfig" },
  },
}
