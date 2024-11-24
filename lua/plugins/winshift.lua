SetKeyBinds {
  n = {
    ["<leader>ws"] = { "<CMD>WinShift<CR>", "winshift shift" },
    ["<leader>ww"] = { "<CMD>WinShift swap<CR>", "winshift shift swap" },
  },
}

return {
  "sindrets/winshift.nvim",
  config = true,
  cmd = "WinShift",
}
