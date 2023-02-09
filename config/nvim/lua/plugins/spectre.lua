local utils = require("utils")

return {
  {
    "nvim-pack/nvim-spectre",
    lazy = true,
    opts = {
      color_devicons = true,
      open_cmd = "vnew",
      live_update = true, -- auto excute search again when you write any file in vim
      line_sep_start = "┌-----------------------------------------",
      result_padding = "¦  ",
      line_sep = "└-----------------------------------------",
      highlight = {
        ui = "String",
        search = "IncSearch",
        replace = "WildMenu",
      },
      mapping = {
        ["toggle_line"] = {
          map = "<Leader>d",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "Spectre Toggle Line",
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "Spectre Select File",
        },
        ["send_to_qf"] = {
          map = "<leader>S",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "Spectre Send To QuickFix",
        },
        ["replace_cmd"] = {
          map = "<leader>r",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "Spectre Replace Current",
        },
        ["show_option_menu"] = {
          map = "<leader>o",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "Spectre Show Options",
        },
        ["run_replace"] = {
          map = "<leader>R",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "Spectre Replace All",
        },
        ["change_view_mode"] = {
          map = "yov",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "Spectre Change View",
        },
        ["toggle_live_update"] = {
          map = "you",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "Spectre Toggle Live Update",
        },
        ["toggle_ignore_case"] = {
          map = "yoi",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "Spectre Toggle Ignore Case",
        },
        ["toggle_ignore_hidden"] = {
          map = "yoh",
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = "Spectre Toggle Ignore Hidden",
        },
        -- you can put your mapping here it only use normal mode
      },
      find_engine = {
        -- rg is map with finder_cmd
        ["rg"] = {
          cmd = "rg",
          -- default args
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case",
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]",
            },
            -- you can put any rg search option you want here it can toggle with
            -- show_option function
          },
        },
        ["ag"] = {
          cmd = "ag",
          args = {
            "--vimgrep",
            "-s",
          },
          options = {
            ["ignore-case"] = {
              value = "-i",
              icon = "[I]",
              desc = "ignore case",
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]",
            },
          },
        },
      },
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = nil,
        },
        options = {
          ["ignore-case"] = {
            value = "--ignore-case",
            icon = "[I]",
            desc = "ignore case",
          },
        },
      },
      default = {
        find = {
          --pick one of item in find_engine
          cmd = "rg",
          options = { "ignore-case" },
        },
        replace = {
          --pick one of item in replace_engine
          cmd = "sed",
        },
      },
      replace_vim_cmd = "cdo",
      is_open_target_win = true, --open file on opener window
      is_insert_mode = false, -- start open panel on is_insert_mode
    },
    keys = {
      { "<Leader>uR", utils.lazy_require("spectre", "open_file_search"), desc = "Spectre File Search" },
      { "<Leader>ur", utils.lazy_require("spectre", "open"), desc = "Spectre Open" },
      {
        "<Leader>ur",
        function()
          require("spectre").open({ search_text = utils.visual_selection() })
        end,
        mode = "v",
        desc = "Spectre Visual",
      },
    },
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },
}
