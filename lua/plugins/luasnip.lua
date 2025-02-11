return {
  "L3MON4D3/LuaSnip",
  version = "2.*",
  dependencies = "rafamadriz/friendly-snippets",
  opts = { history = true, updateevents = "TextChanged,TextChangedI", ext_opts = {} },
  config = function(_, opts)
    local types = require "luasnip.util.types"
    opts.ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<-", "Error" } },
        },
      },
    }
    opts.ft_func = require("luasnip.extras.filetype_functions").from_cursor_pos

    require("luasnip").config.set_config(opts)

    -- vscode format
    require("luasnip.loaders.from_vscode").load()
    require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
    -- require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
    require("luasnip.loaders.from_vscode").load { paths = vim.uv.cwd() .. "/tools/snippets/" }

    -- snipmate format
    require("luasnip.loaders.from_snipmate").load()
    require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

    -- lua format
    require("luasnip.loaders.from_lua").load()
    require("luasnip.loaders.from_lua").load { paths = vim.g.lua_snippets_path or "" }

    local ls = require "luasnip"
    vim.keymap.set({ "i", "s" }, "<A-j>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)
    vim.keymap.set({ "i", "s" }, "<A-h>", function()
      if ls.choice_active() then
        ls.change_choice(-1)
      end
    end)

    vim.keymap.set({ "i", "s" }, "<A-l>", function()
      if ls.jumpable(1) then
        ls.jump(1)
      end
    end)

    vim.keymap.set({ "i", "s" }, "<A-k>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end)

    -- vim.keymap.set({ "i", "s" }, "<Tab>", function()
    --   return ls.expand_or_locally_jumpable() and ls.expand_or_jump() or vim.notify "LOL"
    -- end, { desc = "Luasnip - Jump to next node" })
    --
    -- vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    --   return ls.in_snippet() and ls.jumpable(-1) and ls.jump(-1) or vim.notify "LOL"
    -- end, { desc = "Luasnip - Jump to previous node" })
    --
    -- vim.api.nvim_create_autocmd("InsertLeave", {
    --   callback = function()
    --     if
    --       require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
    --       and not require("luasnip").session.jump_active
    --     then
    --       require("luasnip").unlink_current()
    --     end
    --   end,
    -- })
    opts.ft_func = require("luasnip.extras.filetype_functions").from_cursor_pos
  end,
}
