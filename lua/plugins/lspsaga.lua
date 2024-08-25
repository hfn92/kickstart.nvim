return {
  "nvimdev/lspsaga.nvim",
  lazy = false,
  cmd = "Lspsaga",
  config = function()
    require("lspsaga").setup {
      ui = {
        border = "rounded",
        expand = "⊞",
        collapse = "⊟",
        code_action = "",
        lines = { "┗", "┣", "┃", "━", "┏" },
        button = { "", "" },
      },
      symbols_in_winbar = {
        enable = true,
        folder_level = 3,
      },
      code_action = {
        num_shortcut = true,
        extend_gitsigns = true,
        -- show_server_name = true,
      },
      lightbulb = {
        enable = false,
      },
      rename = {
        in_select = false,
        keys = {
          quit = "<ESC>",
          exec = "<CR>",
          select = "x",
        },
      },
    }
    SetKeyBinds {
      i = {
        ["<A-cr>"] = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
      },
      n = {
        ["<A-cr>"] = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
        ["sd"] = { [[<cmd>Lspsaga peek_definition<CR>]], "Peek definition" },
        ["fd"] = { [[<cmd>Lspsaga finder<CR>]], "Finder" },
      },
    }
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
