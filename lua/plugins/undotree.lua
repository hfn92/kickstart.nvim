return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  init = function()
    SetKeyBinds {
      n = {
        ["<leader>u"] = { vim.cmd.UndotreeToggle, "Undotree" },
      },
    }
  end,
}
