return {
  "rktjmp/lush.nvim",
  lazy = false,
  {
    dir = vim.fn.stdpath "config" .. "/plugins/theme",
  },
  dependencies = {
    "folke/noice.nvim",
  },
}
