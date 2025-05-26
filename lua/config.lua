vim.opt.colorcolumn = "120"
vim.opt.relativenumber = true
vim.opt.scrolloff = 12
vim.opt.smartindent = true

vim.opt.fillchars = { eob = " " }

vim.filetype.add { extension = { fsh = "glsl" } }
vim.filetype.add { extension = { vsh = "glsl" } }
vim.filetype.add { extension = { gsh = "glsl" } }
vim.filetype.add { extension = { shader = "lua" } }
vim.filetype.add { extension = { animation = "toml" } }
vim.filetype.add { extension = { ani = "lua" } }

vim.opt.fillchars:append { diff = "╱" }

vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "context:12",
  "algorithm:histogram",
  "linematch:200",
  "indent-heuristic",
}

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/snippets"
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/snippets"

do
  local x = vim.diagnostic.severity

  -- vim.diagnostic.config {
  --   virtual_text = { prefix = "" },
  --   signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  --   underline = true,
  --   float = { border = "single" },
  -- }
  --
  vim.diagnostic.config {
    virtual_text = true,
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "none" },
  }
end
