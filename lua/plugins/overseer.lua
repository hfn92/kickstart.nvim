return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup {
      templates = { "builtin", "user.conan_install_debug", "user.conan_install_reldeb" },
    }
    SetKeyBinds {
      n = {
        ["<leader>of"] = { "<CMD> OverseerQuickAction open float<CR>", "Overseet open float " },
        ["<leader>oh"] = { "<CMD> OverseerQuickAction open hsplit<CR>", "Overseet open hsplit" },
        ["<leader>ov"] = { "<CMD> OverseerQuickAction open vsplit<CR>", "Overseet open vsplit" },
        ["<leader>oq"] = { "<CMD> OverseerQuickAction open output in quickfix<CR>", "Overseet open quickfix" },
        ["<leader>oo"] = { "<CMD> OverseerToggle left<CR>", "Overseet toggle" },
      },
    }
  end,
  cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
}
