return {
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  "https://github.com/hfn92/lsp_lines.git",
  branch = "test",
  dependencies = { "neovim/nvim-lspconfig" },
  lazy = false,
  config = function()
    require("lsp_lines").setup()

    local toggle = function()
      vim.diagnostic.config {
        virtual_text = not vim.diagnostic.config().virtual_text,
        virtual_lines = not vim.diagnostic.config().virtual_lines,
      }
    end
    -- toggle()

    SetKeyBinds {
      n = {
        ["<leader>tl"] = {
          toggle,
          "toggle lsp_lines",
        },
      },
    }
  end,
}
