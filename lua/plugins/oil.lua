local OIL_TOGGLE = false

SetKeyBinds {
  n = {
    ["-"] = { [[<cmd>Oil<CR>]], "Oil" },
    ["<leader>-"] = {
      function()
        local m = require "oil"
        if OIL_TOOGLE then
          m.set_columns {
            "icon",
            "permissions",
            "size",
            "mtime",
          }
          OIL_TOOGLE = false
        else
          m.set_columns {
            "icon",
          }
          OIL_TOOGLE = true
        end
      end,
      "Oil",
    },
  },
}

return {
  "stevearc/oil.nvim",
  opts = {},
  cmd = { "Oil" },
  -- key = { "-" },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup {
      float = {
        win_options = {
          winblend = 1,
        },
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      columns = {
        "icon",
      },
    }
  end,
}
