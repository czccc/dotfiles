-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "echasnovski/mini.pairs",
    opts = {
      mappings = {
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      },
    },
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      ---@diagnostic disable-next-line: unused-function, unused-local
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local feedkey = function(key, mode, replace)
        if replace then
          key = vim.api.nvim_replace_termcodes(key, true, false, true)
          vim.api.nvim_feedkeys(key, mode, false)
        else
          vim.api.nvim_feedkeys(key, mode, true)
        end
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-y>"] = cmp.mapping.complete(),
        ["<Esc>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              cmp.abort()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.stop()
              end)
              fallback()
            else
              fallback()
            end
          end,
        }),
        ["<Tab>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
              -- elseif has_words_before() then
              --   cmp.complete()
            else
              local next_char = vim.api.nvim_eval("strcharpart(getline('.')[col('.') - 1:], 0, 1)")
              if
                next_char == '"'
                or next_char == "'"
                or next_char == "`"
                or next_char == ")"
                or next_char == "]"
                or next_char == "}"
              then
                feedkey("<Right>", "n", true)
              else
                fallback()
              end
            end
          end,
          s = function(fallback)
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
            else
              fallback()
            end
          end,
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      return opts
    end,
  },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-cmdline",
  --     "dmitmel/cmp-cmdline-history",
  --   },
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "path" },
  --         { name = "cmdline" },
  --         { name = "cmdline_history", max_item_count = 3, keyword_length = 3 },
  --         { name = "nvim_lua" },
  --       },
  --       formatting = {
  --         format = require("utils.lspkind").cmp_format({}),
  --       },
  --     })
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --         { name = "cmdline_history", max_item_count = 3, keyword_length = 3 },
  --       },
  --       formatting = {
  --         format = require("utils.lspkind").cmp_format({}),
  --       },
  --     })
  --     cmp.setup.filetype("markdown", {
  --       sources = cmp.config.sources({
  --         { name = "buffer", max_item_count = 5 },
  --       }),
  --     })
  --
  --     return opts
  --   end,
  -- },
}
