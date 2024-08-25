return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require("which-key").setup {
      icons = {
        -- breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        -- separator = '➜', -- symbol used between a key and it's label
        -- group = '+', -- symbol prepended to a group
        -- ellipsis = '…',
        -- set to false to disable all mapping icons,
        -- both those explicitely added in a mapping
        -- and those from rules
        mappings = false,
      },
    }

    -- Document existing key chains
    require("which-key").add {}
  end,
}
