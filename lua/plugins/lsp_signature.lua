return {
  "ray-x/lsp_signature.nvim",
  config = function()
    require("lsp_signature").setup {
      floating_window = true,
      hint_enable = true,
      hint_scheme = "Keyword",
      hint_prefix = {
        above = "↙ ", -- when the hint is on the line above the current line
        current = "← ", -- when the hint is on the same line
        below = "↖ ", -- when the hint is on the line below the current line
      },
      -- hint_prefix = '',
      hint_inline = function()
        return false
      end,
    }
  end,
}
