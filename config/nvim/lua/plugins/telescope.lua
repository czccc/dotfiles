local utils = require("utils")

return {
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    init = function()
      utils.keymap.group("n", "<Leader>f", "Find Files")
      utils.keymap.group("n", "<Leader>s", "Search")
      utils.keymap.group("n", "<Leader>g", "Git")
    end,
    config = function()
      local previewers = require("telescope.previewers")
      local sorters = require("telescope.sorters")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      require("telescope").setup({
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        -- ignore files bigger than a threshold and don't preview binaries
        buffer_previewer_maker = function(filepath, bufnr, opts)
          opts = opts or {}
          filepath = vim.fn.expand(filepath)
          local Job = require("plenary.job")
          ---@diagnostic disable-next-line: redundant-parameter
          vim.loop.fs_stat(filepath, function(_, stat)
            if not stat then
              return
            end
            if stat.size > 100000 then
              return
            else
              Job:new({
                command = "file",
                args = { "--mime-type", "-b", filepath },
                on_exit = function(j)
                  local mime_type = vim.split(j:result()[1], "/", {})[1]
                  if mime_type == "text" then
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                  else
                    -- maybe we want to write something to the buffer here
                    vim.schedule(function()
                      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                    end)
                  end
                end,
              }):sync()
            end
          end)
        end,
        file_sorter = sorters.get_fuzzy_file,
        generic_sorter = sorters.get_generic_fuzzy_sorter,

        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.75,
            preview_cutoff = 120,
            horizontal = {
              mirror = false,
              preview_width = 0.6,
            },
            vertical = { mirror = false },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--trim", -- add this value
            "--glob=!.git/",
          },
          mappings = {
            i = {
              ["<c-t>"] = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
              end,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<M-p>"] = action_layout.toggle_preview,
            },
            n = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<M-p>"] = action_layout.toggle_preview,
            },
          },
          path_display = { shorten = 10 },
          winblend = 6,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          pickers = {
            find_files = {
              find_command = { "fd", "--type=file", "--hidden", "--smart-case", "--strip-cwd-prefix" },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      })

      require("lazy").load({ plugins = { "telescope-fzf-native.nvim" } })
      require("telescope").load_extension("fzf")
    end,
    keys = {

      -- Git
      { "<Leader>gf", utils.telescope.builtin("git_status"), desc = "Open Changed File" },
      { "<Leader>gb", utils.telescope.builtin("git_branches"), desc = "Checkout Branch" },
      { "<Leader>gB", utils.telescope.builtin("git_stash"), desc = "Checkout Stash" },
      { "<Leader>gc", utils.telescope.builtin("git_commits"), desc = "Checkout Commit" },
      { "<Leader>gC", utils.telescope.builtin("git_bcommits"), desc = "Checkout Current File" },

      -- Find Files
      { "<Leader>fb", utils.telescope.dropdown("current_buffer_fuzzy_find"), desc = "Buffer" },
      {
        "<Leader>fb",
        function()
          utils.telescope.dropdown("current_buffer_fuzzy_find", { default_text = utils.visual_selection() })()
        end,
        desc = "Buffer Visual",
        mode = "v",
      },
      {
        "<Leader>fB",
        function()
          utils.telescope.dropdown("current_buffer_fuzzy_find", { default_text = utils.cur_word() })()
        end,
        desc = "Buffer CurWord",
      },
      { "<Leader>fe", utils.telescope.builtin("oldfiles"), desc = "Old Files" },
      { "<Leader>ff", utils.telescope.builtin("find_files"), desc = "Find Files" },
      { "<Leader>fg", utils.telescope.dropdown("git_files"), desc = "Git Files" },
      { "<Leader>fj", utils.telescope.builtin("jumplist"), desc = "Jump List" },
      { "<Leader>fl", utils.telescope.builtin("resume"), desc = "Resume" },
      { "<Leader>fm", utils.telescope.builtin("masks"), desc = "Marks" },
      { "<Leader>fP", utils.telescope.find_files, desc = "Project FIles" },
      { "<Leader>fr", utils.telescope.workspace_frequency, desc = "Frequency" },
      { "<Leader>fs", utils.telescope.dropdown("git_files"), desc = "Git Status" },
      { "<Leader>fw", utils.telescope.ivy("live_grep"), desc = "Grep" },
      {
        "<Leader>fw",
        function()
          utils.telescope.ivy("live_grep", { default_text = utils.visual_selection() })()
        end,
        desc = "Grep Visual",
        mode = "v",
      },
      {
        "<Leader>fW",
        function()
          utils.telescope.ivy("live_grep", { default_text = utils.cur_word() })()
        end,
        desc = "Grep CurWord",
      },
      { "<Leader>fz", utils.telescope.search_only_certain_files, desc = "Certain Filetype" },

      -- Search
      { "<Leader>sa", utils.telescope.builtin("autocommands"), desc = "Autocommands" },
      { "<Leader>sb", utils.telescope.builtin("git_branches"), desc = "Git Branch" },
      { "<Leader>sc", utils.telescope.builtin("colorscheme"), desc = "Colorschemes" },
      {
        "<Leader>sC",
        utils.telescope.builtin("colorscheme", { enable_preview = true }),
        desc = "Colorschemes with Preview",
      },
      { "<Leader>sh", utils.telescope.builtin("help_tags"), desc = "Find Help" },
      { "<Leader>sH", utils.telescope.builtin("highlights"), desc = "Highlights" },
      { "<Leader>sj", utils.telescope.builtin("command_history"), desc = "Command History" },
      { "<Leader>sJ", utils.telescope.builtin("search_history"), desc = "Search History" },
      { "<Leader>sk", utils.telescope.builtin("keymaps"), desc = "Keymaps" },
      { "<Leader>sl", utils.telescope.builtin("resume"), desc = "Resume" },
      { "<Leader>sm", utils.telescope.builtin("commands"), desc = "Commands" },
      { "<Leader>sM", utils.telescope.builtin("man_pages", { sections = { "1", "3" } }), desc = "Man Pages" },
      { "<Leader>ss", utils.telescope.builtin("builtin"), desc = "Telescope" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    event = { "VeryLazy" },
    dependencies = { "tami5/sqlite.lua", "nvim-telescope/telescope.nvim" },
    config = function(_, _)
      require("telescope").load_extension("frecency")
    end,
    keys = {
      {
        "<Leader>fr",
        "<cmd>Telescope frecency default_text=:CWD:<cr>",
        desc = "Frequency in CWD",
      },
      {
        "<Leader>fR",
        "<cmd>Telescope frecency<cr>",
        desc = "Frequency",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    lazy = true,
    event = { "VeryLazy" },
    config = function(_, _)
      require("harpoon").setup({})
      require("telescope").load_extension("harpoon")
    end,
    keys = {
      -- { "<Leader>fm", utils.lazy_wrap("harpoon.ui", "toggle_quick_menu"), desc = "Harpoon" },
      { "<Leader>fh", "<cmd>Telescope harpoon marks theme=dropdown<cr>", desc = "Harpoon" },
      { "<Leader>fH", utils.lazy_require("harpoon.mark", "add_file"), desc = "Harpoon Add" },
      { "<Leader>fn", utils.lazy_require("harpoon.ui", "nav_next"), desc = "Harpoon Next" },
      { "<Leader>fp", utils.lazy_require("harpoon.ui", "nav_prev"), desc = "Harpoon Previous" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
  {
    "folke/todo-comments.nvim",
    lazy = true,
    event = { "BufReadPost" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
    keys = {
      { "<leader>fT", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
      { "<Leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
