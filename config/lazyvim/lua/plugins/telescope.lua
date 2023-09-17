local utils = require("utils")

return {
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    -- replace all Telescope keymaps with only one mapping
    keys = function()
      return {

        { "<leader>,", utils.telescope("buffers", { show_all_buffers = true }), desc = "Switch Buffer" },
        { "<leader>/", utils.telescope("live_grep"), desc = "Grep (root)" },
        {
          "<leader>/",
          function()
            utils.telescope("live_grep", { default_text = utils.visual_selection() })()
          end,
          mode = "v",
          desc = "Grep (root)",
        },
        { "<leader>:", utils.telescope("command_history"), desc = "Command History" },
        { "<leader><space>", utils.telescope("files"), desc = "Find Files (root)" },

        -- Git
        { "<Leader>gs", utils.telescope("git_status"), desc = "Open Changed File" },
        { "<Leader>gb", utils.telescope("git_branches"), desc = "Checkout Branch" },
        { "<Leader>gS", utils.telescope("git_stash"), desc = "Checkout Stash" },
        { "<Leader>gc", utils.telescope("git_commits"), desc = "Checkout Commit" },
        { "<Leader>gC", utils.telescope("git_bcommits"), desc = "Checkout Current File" },

        -- Find Files
        { "<Leader>fb", utils.telescope("current_buffer_fuzzy_find"), desc = "Buffer" },
        {
          "<Leader>fb",
          function()
            utils.telescope("current_buffer_fuzzy_find", { default_text = utils.visual_selection() })()
          end,
          desc = "Buffer Visual",
          mode = "v",
        },
        {
          "<Leader>fB",
          function()
            utils.telescope("current_buffer_fuzzy_find", { default_text = utils.cur_word() })()
          end,
          desc = "Buffer CurWord",
        },
        { "<Leader>fo", utils.telescope("oldfiles"), desc = "Old Files" },
        { "<Leader>ff", utils.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
        { "<Leader>fg", utils.telescope("git_files"), desc = "Git Files" },
        { "<Leader>fj", utils.telescope("jumplist"), desc = "Jump List" },
        { "<Leader>fl", utils.telescope("resume"), desc = "Resume" },
        { "<Leader>fm", utils.telescope("masks"), desc = "Marks" },
        { "<Leader>fs", utils.telescope("git_files"), desc = "Git Status" },
        { "<Leader>fw", utils.telescope("live_grep", { cwd = false }), desc = "Grep" },
        {
          "<Leader>fw",
          function()
            utils.telescope("live_grep", { cwd = false, default_text = utils.visual_selection() })()
          end,
          desc = "Grep Visual",
          mode = "v",
        },
        {
          "<Leader>fW",
          function()
            utils.telescope("live_grep", { default_text = utils.cur_word() })()
          end,
          desc = "Grep CurWord",
        },

        -- Search
        { '<Leader>s"', utils.telescope("registers"), desc = "Registers" },
        { "<Leader>sa", utils.telescope("autocommands"), desc = "Autocommands" },
        { "<Leader>sb", utils.telescope("git_branches"), desc = "Git Branch" },
        { "<Leader>sc", utils.telescope("commands"), desc = "Colorschemes" },
        {
          "<Leader>sC",
          utils.telescope("colorscheme", { enable_preview = true }),
          desc = "Colorschemes with Preview",
        },
        { "<leader>sd", utils.telescope("diagnostics", { bufnr = 0 }), desc = "Document diagnostics" },
        { "<leader>sD", utils.telescope("diagnostics"), desc = "Workspace diagnostics" },
        { "<Leader>sh", utils.telescope("help_tags"), desc = "Find Help" },
        { "<Leader>sH", utils.telescope("highlights"), desc = "Highlights" },
        { "<Leader>sj", utils.telescope("command_history"), desc = "Command History" },
        { "<Leader>sJ", utils.telescope("search_history"), desc = "Search History" },
        { "<Leader>sk", utils.telescope("keymaps"), desc = "Keymaps" },
        { "<Leader>sl", utils.telescope("resume"), desc = "Resume" },
        { "<Leader>sm", utils.telescope("marks"), desc = "Masks" },
        { "<Leader>sM", utils.telescope("man_pages", { sections = { "1", "3" } }), desc = "Man Pages" },
        { "<Leader>so", utils.telescope("vim_options"), desc = "Options" },
        { "<Leader>sz", utils.telescope("builtin"), desc = "Telescope" },
        {
          "<leader>ss",
          utils.telescope("lsp_document_symbols", {
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          }),
          desc = "Goto Symbol",
        },
        {
          "<leader>sS",
          utils.telescope("lsp_dynamic_workspace_symbols", {
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          }),
          desc = "Goto Symbol (Workspace)",
        },
      }
    end,
    -- replace some options
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix = " ",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          vertical = { width = 0.5, mirror = false },
          horizontal = { preview_width = 0.6, mirror = false },
          -- other layout configuration here
        },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          i = {
            ["<M-p>"] = action_layout.toggle_preview,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<M-t>"] = function(...)
              return require("trouble.providers.telescope").open_selected_with_trouble(...)
            end,
            ["<M-i>"] = function()
              local action_state = require("telescope.actions.state")
              local line = action_state.get_current_line()
              utils.telescope.builtin("find_files", { no_ignore = true, default_text = line })()
            end,
            ["<M-h>"] = function()
              local action_state = require("telescope.actions.state")
              local line = action_state.get_current_line()
              utils.telescope.builtin("find_files", { hidden = true, default_text = line })()
            end,
          },
          n = {
            ["<M-p>"] = action_layout.toggle_preview,
            ["q"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
        },
      })
      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        buffers = { theme = "dropdown" },
        command_history = { theme = "dropdown" },
        live_grep = { theme = "ivy" },
        grep_string = { theme = "ivy" },
      })
      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        frecency = {
          default_workspace = "CWD",
          use_sqlite = false,
          ignore_patterns = { "*.git/*", "*/tmp/*", "term://*", "*neo-tree*" },
        },
      })
    end,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        event = "VeryLazy",
        config = function(_, _)
          require("telescope").load_extension("frecency")
        end,
        keys = {
          {
            "<Leader>fr",
            "<cmd>Telescope frecency<cr>",
            desc = "Frequency in CWD",
          },
          {
            "<Leader>fR",
            "<cmd>Telescope frecency default_text=:*:<cr>",
            desc = "Frequency",
          },
        },
      },
    },
  },
}
