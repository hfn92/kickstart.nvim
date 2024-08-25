return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    -- search = { pattern = [[@(KEYWORDS)]] },
    highlight = {
      -- multiline_pattern = ".",
      -- pattern = [[.*\@<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
    },
  },
}
