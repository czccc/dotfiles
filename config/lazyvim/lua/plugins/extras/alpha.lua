local random_header = function()
  local headers = require("utils.headers")
  math.randomseed(os.time())
  return headers[math.random(1, #headers)]
end

return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      { "<leader>ua", "<cmd>Alpha<cr>", mode = "n", desc = "Alpha" },
    },
    config = function(_, opts)
      local function make_infos()
        local v = vim.version()
        local infos = {}
        table.insert(infos, os.date(" %Y-%m-%d"))
        table.insert(infos, os.date(" %H:%M:%S"))
        table.insert(infos, string.format(" v%d.%d.%d", v.major, v.minor, v.patch))
        local infos_str = table.concat(infos, "     ")
        return {
          type = "text",
          val = infos_str,
          opts = {
            position = "center",
            hl = "Number",
          },
        }
      end

      local dashboard = require("alpha.themes.dashboard")

      opts = {
        layout = {
          -- header
          { type = "padding", val = 2 },
          {
            type = "text",
            val = random_header(),
            opts = {
              position = "center",
              hl = "Type",
              wrap = "overflow",
            },
          },

          -- buttons
          { type = "padding", val = 2 },
          {
            type = "group",
            val = {
              dashboard.button("e", "  > File Explore", ":Neotree filesystem<CR>"),
              dashboard.button("E", "  > New file", ":ene <BAR> startinsert <CR>"),
              dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
              dashboard.button("F", "  > Find ...", ":Telescope<CR>"),
              dashboard.button("r", "  > Recent Files", ":Telescope frecency<CR>"),
              dashboard.button("q", "  > Quit NVIM", ":q<CR>"),
            },
            opts = {
              spacing = 1,
            },
          },

          -- session_list
          -- { type = "padding", val = 2 },
          -- make_sessions(),

          -- nvim infos
          { type = "padding", val = 2 },
          make_infos(),

          -- footer
          { type = "padding", val = 1 },
          {
            type = "text",
            val = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
            end,
            opts = {
              position = "center",
              hl = "Number",
            },
          },
        },
        opts = {
          margin = 5,
        },
      }
      require("alpha").setup(opts)
    end,
  },
}
