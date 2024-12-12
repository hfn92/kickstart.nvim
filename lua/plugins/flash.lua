return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    char = {
      keys = {},
    },
  },
  -- stylua: ignore
  keys = {
    { "<S-CR>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "<CR>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "<CR>", mode = { "n", "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },

  config = function()
    require("flash").setup {
      modes = {
        --(...)
        char = {
          --(...)
          -- by default all keymaps are enabled, but you can disable some of them,
          -- by removing them from the list.
          -- If you rather use another key, you can map them
          -- to something else, e.g., { [";"] = "L", [","] = H }
          keys = {},
          --(...)
        },
        --(...)
      },
    }
    -- vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#3D3E40" })
    -- vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "#C5C8C2" })
    -- vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#C5C8C2" })
    vim.api.nvim_set_hl(0, "FlashLabel", { link = "Error" })
  end,
}
