return {
  {
    "ggandor/lightspeed.nvim",
    lazy = true,
    event = { "BufReadPost" },
    opts = {
      ignore_case = true,
      --- f/t ---
      limit_ft_matches = 4,
      repeat_ft_with_target_char = false,
    },
  },
  {
    "phaazon/hop.nvim",
    lazy = true,
    event = { "BufReadPost" },
    cmd = { "HopChar2", "HopWord" },
    opts = {
      keys = "etovxqpdygfblzhckisuran",
      jump_on_sole_occurrence = true,
      create_hl_autocmd = false,
    },
    keys = {
      -- Key("n", "s", "<cmd>HopChar2MW<cr>", "HopChar2")
      -- Key({ "v", "x", "o" }, "s", "<cmd>HopChar2<cr>", "HopChar2")
      { "<Leader>w", "<cmd>HopWord<cr>", desc = "HopWord" },
      { "<Leader>W", "<cmd>HopWordMW<cr>", desc = "HopWord MW" },

      -- TODO: add keys

      -- utils.load_wk({
      --   name = "Hop",
      --   j = { "<cmd>HopWordMW<cr>", "HopWord MW" },
      --   w = { "<cmd>HopWord<cr>", "HopWord" },
      --   W = { "<cmd>HopWordMW<cr>", "HopWord MW" },
      --   p = { "<cmd>HopPattern<cr>", "HopPattern" },
      --   P = { "<cmd>HopPatternMW<cr>", "HopPattern MW" },
      --   C = { "<cmd>HopChar2<cr>", "HopChar2" },
      --   c = { "<cmd>HopChar1<cr>", "HopChar1" },
      --   l = { "<cmd>HopLine<cr>", "HopLine" },
      --   L = { "<cmd>HopLineStart<cr>", "HopLineStart" },
      -- }, { prefix = "<Leader>j", mode = "n" })

      -- utils.Key({ "v", "x" }, "<Leader>w", "<cmd>HopWord<cr>", "HopWord")
      -- utils.Key({ "v", "x" }, "<Leader>p", "<cmd>HopPattern<cr>", "HopPattern")
      -- utils.Key({ "v", "x" }, "<Leader>l", "<cmd>HopLine<cr>", "HopLine")
      -- utils.Key({ "v", "x" }, "<Leader>L", "<cmd>HopLineStart<cr>", "HopLineStart")
      -- utils.Key({ "v", "x" }, "<Leader>c", "<cmd>HopChar1<cr>", "HopChar1")
      -- utils.Key({ "v", "x" }, "<Leader>C", "<cmd>HopChar2<cr>", "HopChar2")
    },
  },
}
