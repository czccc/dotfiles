local M = {}
local Log = require "core.log"

M.packers = {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = vim.fn.has "nvim-0.6" == 1 and "master" or "0.5-compat",
    -- run = ":TSUpdate",
    config = function()
      require("plugins.treesitter").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-treesitter/playground",
    -- cmd: TSHighlightCapturesUnderCursor  TSPlaygroundToggle
  },
  {
    "p00f/nvim-ts-rainbow",
  },
  {
    "andymass/vim-matchup",
  },
  {
    "romgrk/nvim-treesitter-context",
    -- cmd: TSContextEnable, TSContextDisable and TSContextToggle
    -- highlight: TreesitterContext
    config = function()
      require("plugins.treesitter").setup_context()
    end,
  },
  {
    "SmiteshP/nvim-gps",
    config = function()
      require("plugins.treesitter").setup_gps()
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
  },
}

M.opts = {
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
  }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {},
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = true,
    disable = { "latex" },
  },
  context_commentstring = {
    enable = true,
    config = {
      -- Languages that have a single comment style
      typescript = "// %s",
      css = "/* %s */",
      scss = "/* %s */",
      html = "<!-- %s -->",
      svelte = "<!-- %s -->",
      vue = "<!-- %s -->",
      json = "",
    },
  },
  -- indent = {enable = true, disable = {"python", "html", "javascript"}},
  -- TODO seems to be broken
  indent = { enable = true, disable = { "yaml", "python" } },
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
      border = "none",
      peek_definition_code = {
        ["<leader>lpf"] = "@function.outer",
        ["<leader>lpF"] = "@class.outer",
      },
    },
  },
  textsubjects = {
    enable = false,
    keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
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
    colors = {
      -- "#ca72e4",
      -- "#97ca72",
      -- "#ef5f6b",
      -- "#d99a5e",
      -- "#5ab0f6",
      -- "#ebc275",
      -- "#4dbdcb",
    }, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
    require("core.colors").define_styles("rainbowcol1", { guifg = "#4dbdcb" }),
  },
}

function M.setup()
  -- avoid running in headless mode since it's harder to detect failures
  if #vim.api.nvim_list_uis() == 0 then
    Log:debug "headless mode detected, skipping running setup for treesitter"
    return
  end

  local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    Log:error "Failed to load nvim-treesitter.configs"
    return
  end

  treesitter_configs.setup(M.opts)

  local wk = require "plugins.which_key"
  wk.register(M.opts.textobjects.select.keymaps, { mode = "o", prefix = "", preset = true })
  wk.register({
    ["]f"] = "Next Function Start",
    ["]c"] = "Next Class Start",
    ["]F"] = "Next Function End",
    ["]C"] = "Next Class End",
    ["[f"] = "Previous Function Start",
    ["[c"] = "Previous Class Start",
    ["[F"] = "Previous Function End",
    ["[C"] = "Previous Class End",
  }, { mode = "n", prefix = "", preset = true })
end

M.setup_gps = function()
  require("nvim-gps").setup {

    disable_icons = false, -- Setting it to true will disable all icons

    icons = {
      ["class-name"] = " ", -- Classes and class-like objects
      ["function-name"] = " ", -- Functions
      ["method-name"] = " ", -- Methods (functions inside class-like objects)
      ["container-name"] = "⛶ ", -- Containers (example: lua tables)
      ["tag-name"] = "炙", -- Tags (example: html tags)
    },

    -- Add custom configuration per language or
    -- Disable the plugin for a language
    -- Any language not disabled here is enabled by default
    languages = {
      -- Some languages have custom icons
      ["json"] = {
        icons = {
          ["array-name"] = " ",
          ["object-name"] = " ",
          ["null-name"] = "[] ",
          ["boolean-name"] = "ﰰﰴ ",
          ["number-name"] = "# ",
          ["string-name"] = " ",
        },
      },
      ["latex"] = {
        icons = {
          ["title-name"] = "# ",
          ["label-name"] = " ",
        },
      },
      ["norg"] = {
        icons = {
          ["title-name"] = " ",
        },
      },
      ["toml"] = {
        icons = {
          ["table-name"] = " ",
          ["array-name"] = " ",
          ["boolean-name"] = "ﰰﰴ ",
          ["date-name"] = " ",
          ["date-time-name"] = " ",
          ["float-name"] = " ",
          ["inline-table-name"] = " ",
          ["integer-name"] = "# ",
          ["string-name"] = " ",
          ["time-name"] = " ",
        },
      },
      ["verilog"] = {
        icons = {
          ["module-name"] = " ",
        },
      },
      ["yaml"] = {
        icons = {
          ["mapping-name"] = " ",
          ["sequence-name"] = " ",
          ["null-name"] = "[] ",
          ["boolean-name"] = "ﰰﰴ ",
          ["integer-name"] = "# ",
          ["float-name"] = " ",
          ["string-name"] = " ",
        },
      },
      ["yang"] = {
        icons = {
          ["module-name"] = " ",
          ["augment-path"] = " ",
          ["container-name"] = " ",
          ["grouping-name"] = " ",
          ["typedef-name"] = " ",
          ["identity-name"] = " ",
          ["list-name"] = "﬘ ",
          ["leaf-list-name"] = " ",
          ["leaf-name"] = " ",
          ["action-name"] = " ",
        },
      },

      -- Disable for particular languages
      -- ["bash"] = false, -- disables nvim-gps for bash
      -- ["go"] = false,   -- disables nvim-gps for golang

      -- Override default setting for particular languages
      -- ["ruby"] = {
      --	separator = '|', -- Overrides default separator with '|'
      --	icons = {
      --		-- Default icons not specified in the lang config
      --		-- will fallback to the default value
      --		-- "container-name" will fallback to default because it's not set
      --		["function-name"] = '',    -- to ensure empty values, set an empty string
      --		["tag-name"] = ''
      --		["class-name"] = '::',
      --		["method-name"] = '#',
      --	}
      --}
    },

    separator = " > ",

    -- limit for amount of context shown
    -- 0 means no limit
    depth = 0,

    -- indicator used when context hits depth limit
    depth_limit_indicator = "..",
  }
end

M.setup_context = function()
  require("treesitter-context").setup {
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
        -- 'for', -- These won't appear in the context
        -- 'while',
        -- 'if',
        -- 'switch',
        -- 'case',
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
  }
end

return M
