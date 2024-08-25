vim.opt.colorcolumn = "120"
vim.opt.relativenumber = true
vim.opt.scrolloff = 12
vim.opt.smartindent = true
vim.opt.clipboard = ""

vim.opt.fillchars = { eob = " " }

vim.filetype.add { extension = { fsh = "glsl" } }
vim.filetype.add { extension = { vsh = "glsl" } }
vim.filetype.add { extension = { gsh = "glsl" } }
vim.filetype.add { extension = { shader = "lua" } }
vim.filetype.add { extension = { animation = "toml" } }
vim.filetype.add { extension = { ani = "lua" } }

vim.opt.fillchars:append { diff = "╱" }

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/snippets"
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/snippets"

do
  local x = vim.diagnostic.severity

  vim.diagnostic.config {
    virtual_text = { prefix = "" },
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "single" },
  }
end
