local function GitSignCodeAction()
  local ok, gitsigns_actions = pcall(require("gitsigns").get_actions)
  if not ok or not gitsigns_actions then
    return
  end

  local names = {}
  for name in pairs(gitsigns_actions) do
    table.insert(names, name)
  end

  vim.ui.select(names, { prompt = "Select launch target" }, function(_, idx)
    if not idx then
      return
    end
    gitsigns_actions[names[idx]]()
  end)
end

return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "│" },
    },
  },
  config = function(_, opt)
    require("gitsigns").setup(opt)
    SetKeyBinds {
      n = {
        ["<leader>gs"] = { "<cmd>Gitsigns stage_hunk<CR>", "git stage hunk" },
        ["<leader>gu"] = { "<cmd>Gitsigns undo_stage_hunk<CR>", "git unstage hunk" },
        ["<leader>gq"] = { "<cmd>Gitsigns setqflist<CR>", "git diffs quickfix" },
        ["<A-p>"] = { "<cmd>Gitsigns preview_hunk_inline<CR>", "git preview hunk inline" },
        ["<C-g>"] = {
          function()
            GitSignCodeAction()
          end,
          "Location previous",
        },
        ["]c"] = {
          function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              require("gitsigns").next_hunk()
            end)
            return "<Ignore>"
          end,
          "Jump to next hunk",
          opts = { expr = true },
        },

        ["[c"] = {
          function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              require("gitsigns").prev_hunk()
            end)
            return "<Ignore>"
          end,
          "Jump to prev hunk",
          opts = { expr = true },
        },
      },
    }
  end,
}
