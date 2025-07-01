return {
  "stevearc/overseer.nvim",
  config = function()
    local overseer = require "overseer"

    overseer.setup {
      templates = { "builtin" },
      user_template_dir = ".overseer",
    }

    local scan = require "plenary.scandir"
    local path = require "plenary.path"
    local dbh_path = path:new "./tools/overseer"

    -- vim.notify "loading "
    if dbh_path:exists() then
      local files = scan.scan_dir(dbh_path.filename, {})
      for _, v in ipairs(files) do
        -- vim.notify("loading " .. v)
        local data = dofile(v)
        overseer.register_template(data)
      end
    end

    -- overseer.register_template(require "path.to.my.template")

    SetKeyBinds {
      n = {
        ["<leader>of"] = { "<CMD> OverseerQuickAction open float<CR>", "Overseet open float " },
        ["<leader>oh"] = { "<CMD> OverseerQuickAction open hsplit<CR>", "Overseet open hsplit" },
        ["<leader>ov"] = { "<CMD> OverseerQuickAction open vsplit<CR>", "Overseet open vsplit" },
        ["<leader>oc"] = { "<CMD> OverseerQuickAction open<CR>", "Overseet open current" },
        ["<leader>oq"] = { "<CMD> OverseerQuickAction open output in quickfix<CR>", "Overseet open quickfix" },
        ["<leader>oo"] = { "<CMD> OverseerToggle left<CR>", "Overseet toggle" },
      },
    }
  end,
  cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
}
