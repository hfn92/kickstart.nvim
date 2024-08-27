local function setup()
  local dap = require "dap"

  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
  vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "DapStopped" })

  dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
    name = "lldb",
  }

  local mason_registry = require "mason-registry"
  local codelldb = mason_registry.get_package "codelldb" -- note that this will error if you provide a non-existent package name

  -- dap.adapters.codelldb = {
  --   stopOnEntry = false,
  --   type = "executable",
  --   command = "/home/fab/Work/lua_debugger/build/Debug/luadbg",
  --   -- args = { "--port", "${port}" },
  --
  --   -- On windows you may have to uncomment this:
  --   -- detached = false,
  -- }

  dap.adapters.codelldb = {
    stopOnEntry = false,
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb:get_install_path() .. "/extension/adapter/codelldb",
      args = { "--port", "${port}" },

      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  }
  dap.configurations.cpp = {
    {
      name = "launch",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  SetKeyBinds {
    n = {

      ["<leader>dt"] = {
        function()
          local w = require "dap.ui.widgets"
          w.sidebar(w.threads).open()
        end,
        "Stack frames",
      },
      ["<leader>ds"] = {
        function()
          local w = require "dap.ui.widgets"
          w.centered_float(w.frames)
        end,
        "Stack frames",
      },
      ["<leader>dv"] = {
        function()
          local w = require "dap.ui.widgets"
          w.centered_float(w.scopes)
        end,
        "Variables in Scope",
      },
      ["<leader>dg"] = {
        function()
          local lineNum = vim.api.nvim_win_get_cursor(0)[1]
          require("dap").goto_(lineNum)
        end,
        "Jump to cursor",
      },
      ["<leader><F9>"] = {
        function()
          local condition = vim.fn.input "Breakpoint Condition: "
          local hitcount = vim.fn.input "Hit count: "
          require("dap").toggle_breakpoint(condition, hitcount)
        end,
        "toogle breakpoint condition",
      },

      -- stylua: ignore start
      ["<C-UP>"]        = { function() require("dap").run_to_cursor() end, "Run to cursor", },
      ["<C-DOWN>"]      = { function() require("dap").step_over() end, "step over", },
      ["<C-RIGHT>"]     = { function() require("dap").step_into() end, "step into", },
      ["<C-LEFT>"]      = { function() require("dap").step_out() end, "step out", },
      ["<F4>"]          = { function() require("dap").pause() end, "continue", },
      ["<F5>"]          = { function() require("dap").continue() end, "continue", },
      ["<F6>"]          = { function() require("dap").restart() end, "restart", },
      ["<F7>"]          = { function() require("dap").run_last() end, "run last", },
      ["<F9>"]          = { function() require("dap").toggle_breakpoint() end, "toogle breakpoint", },
      ["<A-DOWN>"]      = { function() require("dap").up() end, "go up in stack", },
      ["<A-UP>"]        = { function() require("dap").down() end, "go down in stack", },
      ["<leader>dr"]    = { function() require("dap").run_last() end, "restart/rerun debug session", },
      ["<leader>du"]    = { function() require("dapui").toggle() end, "Toggle Debug UI", },
      ["<leader>dq"]    = { function() require("dap").terminate() end, "Stop debugging", },
      ["<leader>db"]    = { function() require("dap").pause() end, "Pause", },
      ["<leader>dc"]    = { function() require("dap").clear_breakpoints() end, "Clear breakpoints", },
      ["<leader>dl"]    = { function() require("dap").list_breakpoints() end, "List breakpoints", },
      ["<leader>do"]    = { function() require("dap").repl.toggle() end, "Open repl", },
      ["<leader>dh"]    = { function() require("dap.ui.widgets").hover() end, "Hover", },
      ["<leader>dp"]    = { function() require("dap.ui.widgets").preview() end, "Preview", },
      ["<leader>dz"]    = { function() require("dap.ui.widgets").update_render() {} end, "Refresh", },
      ["<leader>de"]    = { function() require('dap').set_exception_breakpoints() end, "Set exceptions breakpoints", },
      -- stylua: ignore end
      -- ["<leader>dot"] = { function() local w = require "dap.ui.widgets" w.sidebar(w.threads).open() end, "Threds in sidebar", },
      -- ["<leader>dof"] = { function() local w = require "dap.ui.widgets" w.sidebar(w.frames).open() end, "Stack frames sidebar", },
      -- ["<leader>dos"] = { function() local w = require "dap.ui.widgets" w.sidebar(w.scopes).open() end, "Variables in Scope sidebar", },
    },
  }
end

return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function()
      require("nvim-dap-virtual-text").setup {
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        display_callback = function(variable, _buf, _stackframe, _node)
          return variable.name .. "=" .. variable.value
        end,

        -- experimental features:
        virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
  {
    -- "rcarriga/nvim-dap-ui",
    "hfn92/nvim-dap-ui",
    branch = "custom_scopes",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup {
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.25 },
              { id = "console", size = 0.25 },
              { id = "stacks", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
            },
            position = "bottom",
            size = 14,
          },
          {
            elements = {
              { id = "scopes", size = 0.85 },
              { id = "watches", size = 0.15 },
            },
            position = "left",
            size = 80,
          },
        },
      }
    end,
  },
}
