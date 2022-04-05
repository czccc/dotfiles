local M = {}

M.setup = function()
  local status_ok, rust_tools = pcall(require, "rust-tools")
  if not status_ok then
    return
  end

  local lsp_installer_servers = require "nvim-lsp-installer.servers"
  local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"

  local opts = {
    tools = {
      autoSetHints = true,
      hover_with_actions = true,
      executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
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
      cmd_env = requested_server._default_options.cmd_env,
      on_attach = require("plugins.lsp").common_on_attach,
      on_init = require("plugins.lsp").common_on_init,
    },
  }
  rust_tools.setup(opts)
end

require("plugins.which_key").register({
  ["m"] = {
    t = { "<cmd>RustToggleInlayHints<cr>", "Toggle Inlay Hints" },
    r = { "<cmd>RustRunnables<cr>", "Runnables" },
    d = { "<cmd>RustDebuggables<cr>", "Debuggables" },
    e = { "<cmd>RustExpandMacro<cr>", "Expand Macro" },
    c = { "<cmd>RustOpenCargo<cr>", "Open Cargo" },
    R = { "<cmd>RustReloadWorkspace<cr>", "Reload" },
    a = { "<cmd>RustHoverActions<cr>", "Hover Actions" },
    A = { "<cmd>RustHoverRange<cr>", "Hover Range" },
    l = { "<cmd>RustJoinLines<cr>", "Join Lines" },
    j = { "<cmd>RustMoveItemDown<cr>", "Move Item Down" },
    k = { "<cmd>RustMoveItemUp<cr>", "Move Item Up" },
    p = { "<cmd>RustParentModule<cr>", "Parent Module" },
    s = { "<cmd>RustSSR<cr>", "Structural Search Replace" },
    g = { "<cmd>RustViewCrateGraph<cr>", "View Crate Graph" },
    S = { "<cmd>RustStartStandaloneServerForBuffer <cr>", "Standalone Server" },
  },
})

return M
