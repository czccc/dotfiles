local random_header = function()
  local headers = require("utils.headers")
  math.randomseed(os.time())
  return headers[math.random(1, #headers)]
end

local separator = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
local join = function(...)
  return table.concat({ ... }, separator)
end

return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "Shatur/neovim-session-manager" },
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

      local function make_sessions()
        local function shorten_path(filename)
          if #filename > 35 then
            filename = require("plenary.path"):new(filename):shorten()
          end
          if #filename > 35 then
            filename = "..." .. string.sub(filename, -34, -1)
          end
          return filename
        end

        local session_list = require("session_manager.utils").get_sessions()
        local last_session = require("session_manager.utils").get_last_session_filename()

        local buttons = {
          type = "group",
          val = {
            dashboard.button("p", "  > Sessions Pick", ":SessionManager load_session<CR>"),
            dashboard.button("s", "  > Restore Current Session", ":SessionManager load_current_dir_session<CR>"),
            dashboard.button("l", "  > Restore Last Session", ":SessionManager load_last_session<CR>"),
          },
          opts = {
            spacing = 1,
          },
        }
        local idx = 0
        for _, session in ipairs(session_list) do
          idx = idx + 1
          if idx > 9 then
            return buttons
          end
          local desc = " "
          if session.dir.filename == vim.loop.cwd() then
            desc = desc .. "(s)"
          end
          if session.filename == last_session then
            desc = desc .. "(l)"
          end
          local but = dashboard.button(
            string.format("%d", idx),
            "  > " .. shorten_path(session.dir.filename) .. desc,
            string.format(":lua require('session_manager.utils').load_session('%s')<CR>", session.filename)
          )
          table.insert(buttons.val, but)
        end

        return buttons
      end

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
          { type = "padding", val = 2 },
          make_sessions(),

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
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "Shatur/neovim-session-manager",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    init = function()
      local sessions_dir = join(vim.fn.stdpath("data"), "sessions")
      local stat = vim.loop.fs_stat(sessions_dir)
      if not stat then
        vim.fn.system({
          "mkdir",
          sessions_dir,
        })
      end
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "SessionLoadPost",
      --   callback = function()
      --     local neotree_status_ok, _ = pcall(require, "neo-tree.command")
      --     if neotree_status_ok then
      --       pcall(vim.cmd, [[ Neotree ]])
      --       pcall(vim.cmd, [[ wincmd = ]])
      --       return
      --     end
      --   end,
      -- })
    end,
    opts = {
      sessions_dir = join(vim.fn.stdpath("data"), "sessions"), -- The directory where the session files will be saved.
      -- path_replacer = "__", -- The character to which the path separator will be replaced for session files.
      -- colon_replacer = "++", -- The character to which the colon symbol will be replaced for session files.
      autoload_mode = "Disabled", -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
      autosave_last_session = true, -- Automatically save last session on exit and on session switch.
      autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
      autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
        "gitcommit",
        "Outline",
        "NvimTree",
        "neo-tree",
        "nofile",
      },
      autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
      max_path_length = 120, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
    },
    keys = {
      { "<Leader>sp", "<cmd>SessionManager load_session<cr>", desc = "Projects" },
      { "<Leader>qs", "<cmd>SessionManager save_current_session<cr>", desc = "Save" },
      { "<Leader>qc", "<cmd>SessionManager load_current_dir_session<cr>", desc = "Restore CurDir" },
      { "<Leader>ql", "<cmd>SessionManager load_last_session<cr>", desc = "Restore Last" },
      { "<Leader>qd", "<cmd>SessionManager delete_session<cr>", desc = "Delete" },
      { "<Leader>qp", "<cmd>SessionManager load_session<cr>", desc = "List" },
    },
  },
}
