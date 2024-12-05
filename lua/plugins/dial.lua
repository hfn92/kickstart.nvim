---@type LazySpec
return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require "dial.augend"
    require("dial.config").augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
      },
      visual = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.constant.alias.bool,
      },
    }
  end,
  -- stylua: ignore
  keys = {
    {
      "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, "n",
      "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, "n",
      "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, "v",
      "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, "v",
    },
  },
}
