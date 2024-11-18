return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
    -- { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function()
    require("codecompanion").setup {
      display = {
        chat = {
          render_headers = false,
        },
      },
      adapters = {
        qwen = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "qwen2.5-coder:7b",
              },
              -- num_ctx = {
              --   default = 16384,
              -- },
              -- num_predict = {
              --   default = -1,
              -- },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "qwen",
        },
        inline = {
          adapter = "qwen",
        },
      },
    }
  end,
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
}
