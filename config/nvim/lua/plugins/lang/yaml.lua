return {

  -- add to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "yaml" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              hover = true,
              completion = true,
              validate = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemas = {
                kubernetes = {
                  "daemon.{yml,yaml}",
                  "manager.{yml,yaml}",
                  "restapi.{yml,yaml}",
                  "role.{yml,yaml}",
                  "role_binding.{yml,yaml}",
                  "*onfigma*.{yml,yaml}",
                  "*ngres*.{yml,yaml}",
                  "*ecre*.{yml,yaml}",
                  "*eployment*.{yml,yaml}",
                  "*ervic*.{yml,yaml}",
                  "kubectl-edit*.yaml",
                },
              },
            },
          },
        },
      },
    },
  },
}
