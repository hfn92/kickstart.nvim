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
        http = {
          openai5 = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                -- api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
                api_key = "OPENAI_API_KEY",
              },
              schema = {
                model = {
                  default = "gpt-4.1",
                },
              },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                -- api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
                api_key = "OPENAI_API_KEY",
              },
              -- schema = {
              --   model = {
              --     -- default = "gpt-5",
              --   },
              -- },
            })
          end,
          -- qwen = function()
          --   return require("codecompanion.adapters").extend("ollama", {
          --     name = "qwen", -- Give this adapter a different name to differentiate it from the default ollama adapter
          --     schema = {
          --       model = {
          --         default = "qwen2.5-coder:14b",
          --       },
          --       -- num_ctx = {
          --       --   default = 16384,
          --       -- },
          --       -- num_predict = {
          --       --   default = -1,
          --       -- },
          --     },
          --   })
          -- end,
        },
      },
      strategies = {
        chat = {
          -- adapter = "qwen",
          adapter = "openai5",
        },
        inline = {
          -- adapter = "qwen",
          adapter = "openai5",
        },
      },
    }

    SetKeyBinds {
      n = {
        ["<leader>aa"] = { "<cmd> CodeCompanionChat toggle <CR>", "CodeCompanionActions toggle" },
      },
    }
  end,
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
}
