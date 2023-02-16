local utils = require("utils")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufReadPost",
    opts = {
      diagnostics = {
        virtual_text = { spacing = 4, prefix = "●" },
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
      autoformat = true,
      format = {
        formatting_options = nil,
        timeout_ms = 1000,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {},
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    init = function()
      utils.keymap.group("n", "<Leader>l", "LSP")
    end,
    config = function(spec, opts)
      local lspconfig = require("lspconfig")

      -- setup diagnostic and sign
      for _, sign in ipairs(utils.icons.diagnostic) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- setup autoformat
      require("plugins.lsp.utils").autoformat = opts.autoformat
      -- setup formatting and keymaps
      require("plugins.lsp.utils").on_attach(function(client, buffer)
        require("plugins.lsp.utils").set_keymaps(client, buffer)
        require("plugins.lsp.keymaps").set_keymaps(client, buffer)
      end)

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- temp fix for lspconfig rename
      -- https://github.com/neovim/nvim-lspconfig/pull/2439
      local mappings = require("mason-lspconfig.mappings.server")
      if not mappings.lspconfig_to_package.lua_ls then
        mappings.lspconfig_to_package.lua_ls = "lua-language-server"
        mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
      end

      local ensure_installed = {}
      local available = require("mason-lspconfig").get_available_servers()
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
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
    enabled = false,
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
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "Mason" },
    keys = { { "<Leader>lI", "<cmd>Mason<cr>", desc = "Installer" } },
    opts = {
      ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
    config = function(plugin, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
    dependencies = { "neovim/nvim-lspconfig" },
  },
}
