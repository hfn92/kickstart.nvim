return {
  -- {
  --   dir = vim.fn.stdpath "config" .. "/plugins/decorator",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = true,
  --   ft = { "cpp", "lua", "markdown" },
  -- },
  {
    dir = vim.fn.stdpath "config" .. "/plugins/postfix_helper",
  },
  {
    dir = vim.fn.stdpath "config" .. "/plugins/progress_bar",
    dependencies = "folke/noice.nvim",
    -- lazy = true,
    -- event = 'VeryLazy',
    config = function()
      require("progress_bar").setup()
    end,
  },
  -- {
  --   "kawre/leetcode.nvim",
  --   -- build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  --   lazy = false,
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     -- "ibhagwan/fzf-lua",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --   },
  --   opts = {
  --     -- configuration goes here
  --   },
  -- },
}
