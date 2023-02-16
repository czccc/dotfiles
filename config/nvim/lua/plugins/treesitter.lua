return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    event = "BufRead",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "go",
        "javascript",
        "json",
        "lua",
        "python",
        "typescript",
        "css",
        "rust",
        "java",
        "yaml",
        "query",
        "markdown",
        "markdown_inline",
        "vim",
        "regex",
        "bash",
        "norg",
      }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      ignore_install = {},
      autopairs = { enable = true },
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        -- matchparen_offscreen = { method = "popup" },
        -- vim.cmd([[ let g:matchup_matchparen_offscreen = {'method': 'popup'} ]]),
        -- vim.cmd([[ let g:matchup_matchparen_offscreen = {'method': 'status_manual'} ]]),
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          if vim.tbl_contains({ "latex" }, lang) then
            return true
          end

          local max_filesize = 1024 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            vim.schedule(function()
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("setlocal noswapfile noundofile")

                if vim.tbl_contains({ "json" }, lang) then
                  vim.cmd("NoMatchParen")
                  vim.cmd("syntax off")
                  vim.cmd("syntax clear")
                  vim.cmd("setlocal nocursorline nolist bufhidden=unload")

                  vim.api.nvim_create_autocmd({ "BufDelete" }, {
                    callback = function()
                      vim.cmd("DoMatchParen")
                      vim.cmd("syntax on")
                    end,
                    buffer = buf,
                  })
                end
              end)
            end)

            vim.notify("File larger than 1MB, turned off treesitter for this buffer")

            return true
          end
        end,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-n>",
          node_incremental = "<C-n>",
          scope_incremental = "<C-m>",
          node_decremental = "<C-r>",
        },
      },
      context_commentstring = {
        enable = true,
        config = {
          -- Languages that have a single comment style
          lua = "-- %s",
          typescript = "// %s",
          css = "/* %s */",
          scss = "/* %s */",
          html = "<!-- %s -->",
          svelte = "<!-- %s -->",
          vue = "<!-- %s -->",
          json = "",
        },
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
      autotag = { enable = false },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        swap = {
          enable = false,
          swap_next = {
            ["<leader><M-a>"] = "@parameter.inner",
            ["<leader><M-f>"] = "@function.outer",
            ["<leader><M-e>"] = "@element",
          },
          swap_previous = {
            ["<leader><M-A>"] = "@parameter.inner",
            ["<leader><M-F>"] = "@function.outer",
            ["<leader><M-E>"] = "@element",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        lsp_interop = {
          enable = true,
          border = "rounded",
          peek_definition_code = {
            ["<leader>lf"] = "@function.outer",
            ["<leader>lc"] = "@class.outer",
          },
        },
      },
      textsubjects = {
        enable = false,
        prev_selection = ",",
        keymaps = {
          ["."] = "textsubjects-smart",
          -- [";"] = "textsubjects-big",
          [";"] = "textsubjects-container-outer",
          ["i;"] = "textsubjects-container-inner",
        },
      },
      playground = {
        enable = false,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        -- colors = {
        -- "#ca72e4",
        -- "#97ca72",
        -- "#ef5f6b",
        -- "#d99a5e",
        -- "#5ab0f6",
        -- "#ebc275",
        -- "#4dbdcb",
        -- }, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-treesitter.install").prefer_git = true
    end,
    keys = {
      { "<Leader>ut", "<cmd>TSHighlightCapturesUnderCursor<cr>", desc = "TSHighlightCapturesUnderCursor" },
    },
    dependencies = {
      { "nvim-treesitter/playground", lazy = true, cmd = "TSHighlightCapturesUnderCursor" },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- "RRethy/nvim-treesitter-textsubjects",
      "p00f/nvim-ts-rainbow",
      {
        "andymass/vim-matchup",
        init = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
              "class",
              "function",
              "method",
              "for", -- These won't appear in the context
              "while",
              "if",
              "switch",
              "case",
            },
            rust = {
              "impl_item",
              "struct",
              "enum",
            },
            markdown = {
              "section",
            },
            -- Example for a specific filetype.
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            --   rust = {
            --       'impl_item',
            --   },
          },
          exact_patterns = {
            -- Example for a specific filetype with Lua patterns
            -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
            -- exactly match "impl_item" only)
            -- rust = true,
          },
        },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    lazy = true,
    event = { "VeryLazy", "InsertEnter" },
    opts = {
      ---@usage  modifies the function or method delimiter by filetypes
      map_char = {
        all = "(",
        tex = "{",
      },
      ---@usage check bracket in same line
      enable_check_bracket_line = false,
      ---@usage check treesitter
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      enable_moveright = true,
      ---@usage disable when recording or executing a macro
      disable_in_macro = true,
      ---@usage add bracket pairs after quote
      enable_afterquote = true,
      ---@usage map the <BS> key
      map_bs = true,
      ---@usage map <c-w> to delete a pair if possible
      map_c_w = true,
      ---@usage disable when insert after visual block mode
      disable_in_visualblock = true,
      ---@usage  change default fast_wrap
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
  },
}
