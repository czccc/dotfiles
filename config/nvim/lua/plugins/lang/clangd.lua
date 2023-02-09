local function switch_source_header_splitcmd(bufnr, splitcmd)
  bufnr = require("lspconfig").util.validate_bufnr(bufnr)
  local clangd_client = require("lspconfig").util.get_active_client_by_name(bufnr, "clangd")
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  if clangd_client then
    clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
      if err then
        vim.notify(tostring(err))
      end
      if not result then
        vim.notify("Corresponding file can't be determined")
        return
      end
      vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end, bufnr)
  else
    vim.notify("textDocument/switchSourceHeader is not supported by the clangd server active on the current buffer")
  end
end

return {
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp", "objc", "objcpp" },
    config = function()
      local clangd_extensions = require("clangd_extensions")

      local clangd_flags = {
        "--background-index",
        "-j=12",
        "--all-scopes-completion",
        "--pch-storage=disk",
        "--clang-tidy",
        "--log=error",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        -- "--enable-config",
        "--offset-encoding=utf-16",
        -- "--ranking-model=heuristics",
        -- "--folding-ranges",
      }
      clangd_extensions.setup({
        server = {
          -- options to pass to nvim-lspconfig
          -- i.e. the arguments to require("lspconfig").clangd.setup({})
          cmd = { "clangd", table.unpack(clangd_flags) },
          on_attach = function(client, bufnr)
            require("utils.lsp").common_on_attach(client, bufnr)
            -- utils.load_wk({
            --   name = "Module",
            --   s = { "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source Header" },
            --   S = { "<cmd>ClangdSwitchSourceHeaderSplit<cr>", "Split Source Header" },
            --   v = { "<cmd>ClangdSwitchSourceHeaderVSplit<cr>", "VSplit Source Header" },
            --   i = { "<cmd>ClangdSymbolInfo<cr>", "Symbol Info" },
            --   t = { "<cmd>ClangdTypeHierarchy<cr>", "Type Hierarchy" },
            --   T = { "<cmd>ClangdToggleInlayHints<cr>", "Toggle Inlay Hints" },
            --   m = { "<cmd>ClangdMemoryUsage<cr>", "Memory Usage" },
            --   a = { "<cmd>ClangdAST<cr>", "AST" },
            -- }, { prefix = "<Leader>m", mode = "n", opts = { buffer = bufnr } })
          end,
          capabilities = require("utils.lsp").common_capabilities(),
          commands = {
            ClangdSwitchSourceHeader = {
              function()
                switch_source_header_splitcmd(0, "edit")
              end,
              description = "Open source/header in current buffer",
            },
            ClangdSwitchSourceHeaderVSplit = {
              function()
                switch_source_header_splitcmd(0, "vsplit")
              end,
              description = "Open source/header in a new vsplit",
            },
            ClangdSwitchSourceHeaderSplit = {
              function()
                switch_source_header_splitcmd(0, "split")
              end,
              description = "Open source/header in a new split",
            },
          },
        },
        extensions = {
          -- defaults:
          -- Automatically set inlay hints (type hints)
          autoSetHints = true,
          -- Whether to show hover actions inside the hover window
          -- This overrides the default hover handler
          hover_with_actions = true,
          -- These apply to the default ClangdSetInlayHints command
          inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- wheter to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- whether to show variable name before type hints with the inlay hints or not
            show_variable_name = false,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
          },
        },
      })
    end,
  },
}
