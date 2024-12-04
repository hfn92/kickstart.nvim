return {
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  "https://github.com/hfn92/lsp_lines.git",
  branch = "test",
  dependencies = { "neovim/nvim-lspconfig" },
  lazy = false,
  config = function()
    require("lsp_lines").setup()

    vim.diagnostic.config { virtual_lines = { only_current_line = true } }
    -- vim.diagnostic.config { virtual_lines = { highlight_whole_line = false } }

    local toggle = function()
      local active = vim.diagnostic.config().virtual_lines
      if active then
        vim.diagnostic.config { virtual_lines = false }
      else
        vim.diagnostic.config { virtual_lines = { only_current_line = true } }
      end
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
