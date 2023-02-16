return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    event = { "InsertEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip/loaders/from_vscode").lazy_load()
      require("luasnip/loaders/from_vscode").lazy_load({ paths = { "./snippets" } })
      local types = require("luasnip.util.types")
      local util = require("luasnip.util.util")
      local luasnip = require("luasnip")
      luasnip.config.setup({
        history = false,
        update_events = "InsertLeave",
        enable_autosnippets = true,
        region_check_events = "CursorHold,InsertLeave",
        delete_check_events = "TextChanged,InsertEnter",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "●", "GruvboxOrange" } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { "●", "GruvboxBlue" } },
            },
          },
        },
        parser_nested_assembler = function(_, snippet)
          local select = function(snip, no_move)
            snip.parent:enter_node(snip.indx)
            -- upon deletion, extmarks of inner nodes should shift to end of
            -- placeholder-text.
            for _, node in ipairs(snip.nodes) do
              node:set_mark_rgrav(true, true)
            end

            -- SELECT all text inside the snippet.
            if not no_move then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              local pos_begin, pos_end = snip.mark:pos_begin_end()
              util.normal_move_on(pos_begin)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), "n", true)
              util.normal_move_before(pos_end)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o<C-G>", true, false, true), "n", true)
            end
          end
          function snippet:jump_into(dir, no_move)
            if self.active then
              -- inside snippet, but not selected.
              if dir == 1 then
                self:input_leave()
                return self.next:jump_into(dir, no_move)
              else
                select(self, no_move)
                return self
              end
            else
              -- jumping in from outside snippet.
              self:input_enter()
              if dir == 1 then
                select(self, no_move)
                return self
              else
                return self.inner_last:jump_into(dir, no_move)
              end
            end
          end

          -- this is called only if the snippet is currently selected.
          function snippet:jump_from(dir, no_move)
            if dir == 1 then
              return self.inner_first:jump_into(dir, no_move)
            else
              self:input_leave()
              return self.prev:jump_into(dir, no_move)
            end
          end

          return snippet
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local types = require("cmp.types")
      local luasnip = require("luasnip")

      local feedkey = function(key, mode, replace)
        if replace then
          key = vim.api.nvim_replace_termcodes(key, true, false, true)
          vim.api.nvim_feedkeys(key, mode, false)
        else
          vim.api.nvim_feedkeys(key, mode, true)
        end
      end

      local config = {
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
        experimental = {
          ghost_text = { hl_group = "LspCodeLens" },
        },
        formatting = {
          format = require("utils.lspkind").cmp_format({ maxwidth = 50 }),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "path", max_item_count = 5, keyword_length = 3 },
          { name = "luasnip", max_item_count = 5 },
          { name = "nvim_lua" },
          { name = "buffer", max_item_count = 5, keyword_length = 3 },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Esc>"] = {
            i = function(fallback)
              if cmp.visible() then
                cmp.abort()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] = nil
                fallback()
              else
                fallback()
              end
            end,
          },
          ["<Tab>"] = {
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.jumpable() then
                -- luasnip.jump()
                luasnip.expand_or_jump()
                -- elseif luasnip.expand_or_locally_jumpable() then
                --   luasnip.expand_or_jump()
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
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end,
          },
          ["<S-Tab>"] = {
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
          },
        }),
      }
      cmp.setup(config)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
          { name = "cmdline_history", max_item_count = 3, keyword_length = 3 },
          { name = "nvim_lua" },
        },
        formatting = {
          format = require("utils.lspkind").cmp_format({}),
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
          { name = "cmdline_history", max_item_count = 3, keyword_length = 3 },
        },
        formatting = {
          format = require("utils.lspkind").cmp_format({}),
        },
      })
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "buffer", max_item_count = 5 },
        }),
      })
    end,
  },
}
