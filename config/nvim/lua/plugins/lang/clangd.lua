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

return {

  -- add to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c", "cpp" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "p00f/clangd_extensions.nvim",
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        clangd = {
          cmd = { "clangd", table.unpack(clangd_flags) },
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
          on_attach = function(client, buffer)
            if client.name == "clangd" then
              -- require("clangd_extensions").setup({})
              local utils = require("utils")
              utils.keymap.set(
                "n",
                "<Leader>ms",
                "<cmd>ClangdSwitchSourceHeader<cr>",
                { desc = "Switch Source Header", buffer = buffer }
              )
              utils.keymap.set(
                "n",
                "<Leader>mS",
                "<cmd>ClangdSwitchSourceHeaderSplit<cr>",
                { desc = "Split Source Header", buffer = buffer }
              )
              utils.keymap.set(
                "n",
                "<Leader>mv",
                "<cmd>ClangdSwitchSourceHeaderVSplit<cr>",
                { desc = "VSplit Source Header", buffer = buffer }
              )
              utils.keymap.set(
                "n",
                "<Leader>mi",
                "<cmd>ClangdSymbolInfo<cr>",
                { desc = "Symbol Info", buffer = buffer }
              )
              utils.keymap.set(
                "n",
                "<Leader>mt",
                "<cmd>ClangdTypeHierarchy<cr>",
                { desc = "Type Hierarchy", buffer = buffer }
              )
              utils.keymap.set(
                "n",
                "<Leader>mT",
                "<cmd>ClangdToggleInlayHints<cr>",
                { desc = "Toggle Inlay Hints", buffer = buffer }
              )
              utils.keymap.set(
                "n",
                "<Leader>mm",
                "<cmd>ClangdMemoryUsage<cr>",
                { desc = "Memory Usage", buffer = buffer }
              )
              utils.keymap.set("n", "<Leader>ma", "<cmd>ClangdAST<cr>", { desc = "AST", buffer = buffer })
            end
          end,
        },
      },
      setup = {
        clangd = function(_, opts)
          require("clangd_extensions").setup({ server = opts })
          return true
        end,
      },
    },
  },
}
