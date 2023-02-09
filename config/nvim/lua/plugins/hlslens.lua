return {
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = "BufReadPost",
    opts = {
      show = true,
      set_highlights = true,
      handle = {
        text = " ",
        color = nil,
        cterm = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
      },
      marks = {
        Search = {
          text = { "-", "=" },
          priority = 0,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Error = {
          text = { "-", "=" },
          priority = 1,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "-", "=" },
          priority = 2,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "-", "=" },
          priority = 3,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "-", "=" },
          priority = 4,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-", "=" },
          priority = 5,
          color = nil,
          cterm = nil,
          highlight = "Normal",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "neo-tree",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
      },
      handlers = {
        diagnostic = true,
        search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
      },
    },
    dependencies = {
      { "kevinhwang91/nvim-hlslens" },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    lazy = true,
    event = "BufReadPost",
    opts = {
      auto_enable = true,
      calm_down = true,
      enable_incsearch = true,
      nearest_only = false,
      override_lens = function(render, plist, nearest, idx, r_idx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local abs_r_idx = math.abs(r_idx)
        if abs_r_idx > 1 then
          indicator = string.format("%d%s", abs_r_idx, sfw ~= (r_idx > 1) and "" or "")
        elseif abs_r_idx == 1 then
          indicator = sfw ~= (r_idx == 1) and "" or ""
        else
          indicator = ""
        end

        local lnum, col = table.unpack(plist[idx])
        if nearest then
          local cnt = #plist
          if indicator ~= "" then
            text = string.format("[%s %d/%d]", indicator, idx, cnt)
          else
            text = string.format("[%d/%d]", idx, cnt)
          end
          chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
        else
          text = string.format("[%s %d]", indicator, idx)
          chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
        end
        render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    },
    keys = {
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
        desc = "Search Next",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
        desc = "Search Previous",
      },
      { "*", "*<Cmd>lua require('hlslens').start()<CR>", desc = "Search CurWord Forward" },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>", desc = "Search CurWord Backward" },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>", desc = "Fuzzy CurWord Forward" },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>", desc = "Fuzzy CurWord Backward" },
    },
  },
}
