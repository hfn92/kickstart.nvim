return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local bufferline = require "bufferline"
    require("bufferline").setup {

      options = {
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          -- style = "underline",
        },
        seperator_style = { "x", "asdasd" },
        -- style_preset = bufferline.style_preset.no_italic,
        style_preset = {
          bufferline.style_preset.minimal,
          bufferline.style_preset.no_bold,
        },
        right_mouse_command = function() end,
        buffer_close_icon = "X",
        -- -- or you can combine these e.g.
        -- style_preset = {
        --   bufferline.style_preset.no_italic,
        --   bufferline.style_preset.no_bold,
        -- },
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
      highlights = {},
    }

    SetKeyBinds {
      n = {
        ["<tab>"] = { "<cmd>BufferLineCycleNext<cr>", "Goto next buffer" },
        ["<S-tab>"] = { "<cmd>BufferLineCyclePrev<cr>", "Goto next buffer" },

        -- close buffer + hide terminal buffer
        ["<leader>x"] = { "<cmd>bd<cr>", "Close buffer" },
      },
    }
  end,
  lazy = false,
}