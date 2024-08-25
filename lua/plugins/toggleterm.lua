return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  -- cmd = "ToggleTerm",
  -- key = { "<A-v>" },
  version = "*",
  config = function()
    require("toggleterm").setup {
      -- -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      -- open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
      -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
      -- on_open = fun(t: Terminal), -- function to run when the terminal opens
      -- on_close = fun(t: Terminal), -- function to run when the terminal closes
      -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
      -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
      -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
      -- hide_numbers = true, -- hide the number column in toggleterm buffers
      -- shade_filetypes = {},
      -- autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      highlights = {
        -- highlights which map to a highlight group name and a table of it's values
        -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
        -- Normal = {
        --   guibg = "#FF0000",
        -- },
        NormalFloat = {
          -- guibg = "#FF0000",
          -- link = 'Normal'
        },
        FloatBorder = {
          link = "FloatBorder",
        },
      },
      shade_terminals = false, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
      -- shading_factor = '<number>', -- the percentage by which to lighten dark terminal background, default: -30
      -- shading_ratio = '<number>', -- the ratio of shading factor for light/dark terminal background, default: -3
      -- start_in_insert = true,
      -- insert_mappings = true, -- whether or not the open mapping applies in insert mode
      -- terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      -- persist_size = true,
      -- persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
      -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
      -- close_on_exit = true, -- close the terminal window when the process exits
      -- clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
      --  -- Change the default shell. Can be a string or a function returning a string
      -- shell = vim.o.shell,
      -- auto_scroll = true, -- automatically scroll to the bottom on terminal output
      -- -- This field is only relevant if direction is set to 'float'
      -- float_opts = {
      --   -- The border key is *almost* the same as 'nvim_open_win'
      --   -- see :h nvim_open_win for details on borders however
      --   -- the 'curved' border is a custom border type
      --   -- not natively supported but implemented in this plugin.
      --   border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      --   -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
      --   width = <value>,
      --   height = <value>,
      --   row = <value>,
      --   col = <value>,
      --   winblend = 3,
      --   zindex = <value>,
      --   title_pos = 'left' | 'center' | 'right', position of the title of the floating window
      -- },
      -- winbar = {
      --   enabled = false,
      --   name_formatter = function(term) --  term: Terminal
      --     return term.name
      --   end
      -- },
    }

    local tt = require "toggleterm.terminal"
    local Terminal = tt.Terminal
    local lazygit = Terminal:new {
      cmd = "lazygit",
      -- cmd = string -- command to execute when creating the terminal e.g. 'top'
      -- display_name = string -- the name of the terminal
      -- direction = string -- the layout for the terminal, same as the main config options
      -- dir = string -- the directory for the terminal
      -- close_on_exit = bool -- close the terminal window when the process exits
      -- highlights = table -- a table with highlights
      -- env = table -- key:value table with environmental variables passed to jobstart()
      -- clear_env = bool -- use only environmental variables from `env`, passed to jobstart()
      -- on_open = fun(t: Terminal) -- function to run when the terminal opens
      -- on_close = fun(t: Terminal) -- function to run when the terminal closes
      -- auto_scroll = boolean -- automatically scroll to the bottom on terminal output
      -- -- callbacks for processing the output
      -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
      -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
      -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
    }

    local horizontal = Terminal:new {
      display_name = "horizontal term", -- the name of the terminal
      dir = vim.uv.cwd(), -- the directory for the terminal
      close_on_exit = false, -- close the terminal window when the process exits
    }

    local vertical = Terminal:new {
      display_name = "vertical term", -- the name of the terminal
      dir = vim.uv.cwd(), -- the directory for the terminal
      close_on_exit = false, -- close the terminal window when the process exits
      direction = "vertical",
    }

    local float = Terminal:new {
      display_name = "", -- the name of the terminal
      dir = vim.uv.cwd(), -- the directory for the terminal
      close_on_exit = false, -- close the terminal window when the process exits
      direction = "float",
      float_opts = {
        title = false,
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
        width = function()
          return math.floor(vim.o.columns * 0.6)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.4)
        end,
        -- height = 10,
        -- row = 5,
        -- col = 5,
        -- winblend = 3,
        -- zindex = <value>,
        -- title_pos = 'left' | 'center' | 'right', position of the title of the floating window
      },
    }

    local toogle_vert = {
      function()
        vertical:toggle()
      end,
    }
    local toogle_hor = {
      function()
        horizontal:toggle()
      end,
    }
    local toogle_float = {
      function()
        float:toggle()
      end,
    }

    SetKeyBinds {
      n = {
        ["<A-v>"] = toogle_vert,
        ["<A-h>"] = toogle_hor,
        ["<A-i>"] = toogle_float,
      },
      t = {
        ["<A-v>"] = toogle_vert,
        ["<A-h>"] = toogle_hor,
        ["<A-i>"] = toogle_float,
      },
    }
  end,
}
