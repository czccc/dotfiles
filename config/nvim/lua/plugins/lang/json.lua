return {
  {
    "b0o/schemastore.nvim",
    lazy = true,
    ft = { "json" },
    config = function(spec, opts)
      require("lspconfig")["jsonls"].setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
          },
        },
      })
    end,
  },
}
