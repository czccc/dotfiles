local executor = {}
executor.latest_buf_id = nil
executor.execute_command = function(command, args, cwd)
  local utils = require("rust-tools.utils.utils")
  local full_command = utils.make_command_from_args(command, args)
  utils.delete_buf(executor.latest_buf_id)
  executor.latest_buf_id = vim.api.nvim_create_buf(false, true)

  utils.split(false, executor.latest_buf_id)
  utils.resize(false, "-15")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, true, true), "", true)
  vim.api.nvim_buf_set_keymap(executor.latest_buf_id, "n", "<Esc>", ":q<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(executor.latest_buf_id, "n", "<CR>", "i", { noremap = true })
  vim.api.nvim_buf_set_keymap(executor.latest_buf_id, "n", "<Tab>", "<C-w>k", { noremap = true })

  -- run the command
  vim.fn.termopen(full_command, { cwd = cwd })

  local function onDetach(_, _)
    executor.latest_buf_id = nil
  end

  vim.api.nvim_buf_attach(executor.latest_buf_id, false, { on_detach = onDetach })
end

return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust", "toml" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {},
          },
        },
      },
      setup = {
        rust_analyzer = function()
          require("rust-tools").setup({
            tools = {
              autoSetHints = true,
              executor = executor, -- can be quickfix or termopen
              runnables = {
                use_telescope = true,
                prompt_prefix = "  ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "descending",
                layout_strategy = "vertical",
                layout_config = {
                  width = 0.3,
                  height = 0.50,
                  preview_cutoff = 0,
                  prompt_position = "bottom",
                },
              },
              debuggables = {
                use_telescope = true,
              },
              inlay_hints = {
                only_current_line = false,
                show_parameter_hints = true,
                parameter_hints_prefix = "<-",
                other_hints_prefix = "=>",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
              },
              hover_actions = {
                border = {
                  { "╭", "FloatBorder" },
                  { "─", "FloatBorder" },
                  { "╮", "FloatBorder" },
                  { "│", "FloatBorder" },
                  { "╯", "FloatBorder" },
                  { "─", "FloatBorder" },
                  { "╰", "FloatBorder" },
                  { "│", "FloatBorder" },
                },
                auto_focus = true,
              },
            },
            server = {
              standalone = true,
              settings = {
                ["rust-analyzer"] = {
                  checkOnSave = {
                    command = "clippy",
                  },
                },
              },
              on_attach = function(client, buffer)
                local utils = require("utils")
                utils.keymap.set(
                  "n",
                  "<Leader>mt",
                  "<cmd>RustToggleInlayHints<cr>",
                  { desc = "Toggle Inlay Hints", buffer = buffer }
                )
                utils.keymap.set("n", "<Leader>mr", "<cmd>RustRunnables<cr>", { desc = "Runnables", buffer = buffer })
                utils.keymap.set(
                  "n",
                  "<Leader>md",
                  "<cmd>RustDebuggables<cr>",
                  { desc = "Debuggables", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>me",
                  "<cmd>RustExpandMacro<cr>",
                  { desc = "Expand Macro", buffer = buffer }
                )
                utils.keymap.set("n", "<Leader>mc", "<cmd>RustOpenCargo<cr>", { desc = "Open Cargo", buffer = buffer })
                utils.keymap.set(
                  "n",
                  "<Leader>mR",
                  "<cmd>RustReloadWorkspace<cr>",
                  { desc = "Reload Workspace", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>ma",
                  "<cmd>RustHoverActions<cr>",
                  { desc = "Hover Actions", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>mA",
                  "<cmd>RustHoverRange<cr>",
                  { desc = "Hover Range", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>ml",
                  "<cmd>RustMoveItemDown<cr>",
                  { desc = "Move Item Down", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>mj",
                  "<cmd>RustMoveItemUp<cr>",
                  { desc = "Move Item Up", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>mp",
                  "<cmd>RustParentModule<cr>",
                  { desc = "Parent Module", buffer = buffer }
                )
                utils.keymap.set("n", "<Leader>ms", "<cmd>RustSSR<cr>", { desc = "SSR", buffer = buffer })
                utils.keymap.set(
                  "n",
                  "<Leader>mg",
                  "<cmd>RustViewCrateGraph<cr>",
                  { desc = "View Crate Graph", buffer = buffer }
                )
                utils.keymap.set(
                  "n",
                  "<Leader>mS",
                  "<cmd>RustStartStandaloneServerForBuffer<cr>",
                  { desc = "Standalone Server", buffer = buffer }
                )
              end,
            },
          })
          return true
        end,
      },
    },
  },
}
