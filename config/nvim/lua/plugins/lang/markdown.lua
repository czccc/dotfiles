local utils = require("utils")

return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = "markdown",
    build = "cd app && npm install",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          utils.keymap.set("n", "<Leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Preview", buffer = 0 })
        end,
      })
    end,
  },
  {
    "mzlogin/vim-markdown-toc",
    lazy = true,
    ft = "markdown",
    init = function()
      -- vim.g.vmt_auto_update_on_save = 0
      -- vim.g.vmt_dont_insert_fence = 1
      -- vim.g.vmt_cycle_list_item_markers = 1
      vim.g.vmt_include_headings_before = 1
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          utils.keymap.set("n", "<Leader>mg", "<cmd>GenTocGFM<cr>", { desc = "Gen Toc GFM", buffer = 0 })
          utils.keymap.set("n", "<Leader>mu", "<cmd>UpdateToc<cr>", { desc = "Update Toc", buffer = 0 })
        end,
      })
    end,
  },
}
