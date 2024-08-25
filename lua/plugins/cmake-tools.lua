return {
  -- "Civitasv/cmake-tools.nvim",
  "hfn92/cmake-tools.nvim",
  branch = "overseer_terminal",
  lazy = false,
  config = function()
    require("cmake-tools").setup {
      cmake_build_directory = "build/${variant:buildType}", -- this is used to specify generate directory for cmake
      cmake_regenerate_on_save = true, -- Saves CMakeLists.txt file only if mofified.
      cmake_soft_link_compile_commands = true, -- if softlink compile commands json file
      -- cmake_compile_commands_from_lsp = true,
      cmake_build_options = { "-j32" },

      cmake_executor = { -- executor to use
        name = "quickfix",
        default_opts = { -- a list of default and possible values for executors
          quickfix = {
            show = "only_on_error", -- "always", "only_on_error"
          },
        },
      },
      cmake_runner = {
        name = "overseer",

        opts = { -- a list of default and possible values for runners
          new_task_opts = {
            strategy = {
              "terminal",
              direction = "horizontal",
              autos_croll = true,
              quit_on_exit = "success",
            },
          }, -- options to pass into the `overseer.new_task` command
        },
      },

      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = false,
        initCommands = function()
          local cmds = {}

          local scan = require "plenary.scandir"
          local path = require "plenary.path"
          local dbh_path = path:new "./tools/debughelpers/lldb/"
          if dbh_path:exists() then
            local files = scan.scan_dir(dbh_path.filename, {})
            for _, v in ipairs(files) do
              table.insert(cmds, "command script import " .. v)
            end
          end

          local ok, res = pcall(function()
            return dofile "dap.lua"
          end)
          if ok then
            for _, v in ipairs(res) do
              table.insert(cmds, v)
            end
          end

          table.insert(cmds, [[settings set target.process.thread.step-avoid-regexp '']])
          table.insert(cmds, [[breakpoint name configure --disable cpp_exception]])
          return cmds
        end,
      },

      hooks = {
        on_progress = function(prog)
          -- vim.notify(vim.inspect(prog))
          require("progress_bar").progress {
            client_id = 999901,
            result = {
              token = 0,
              client = "cmake",
              value = prog,
            },
          }
          -- vim.notify(vim.inspect(prog))
        end,
      },

      SetKeyBinds {
        i = {
          ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake [b]uild" },
        },
        n = {
          ["<leader>cg"] = { "<cmd> CMakeGenerate<CR>", "CMake Generate" },
          ["<leader>cy"] = { "<cmd> CMakeSelectBuildType<CR>", "Select build type" },
          ["<leader>ct"] = { "<cmd> CMakeSelectBuildTarget <CR>", "Select CMake target" },
          ["<leader>cp"] = { "<cmd> CMakeSelectBuildPreset<CR>", "Select CMake preset" },
          ["<leader>cb"] = { "<cmd> CMakeBuild <CR>", "CMake build" },
          -- ["<leader>cs"] = { "<cmd> CMakeStopE <CR>", "CMake stop" },
          ["<leader>cs"] = { "<cmd> CMakeStop <CR>", "CMake stop" },
          ["<leader>cd"] = { "<cmd> CMakeDebug <CR>", "CMake debug" },
          ["<leader>ca"] = {
            function()
              local args = vim.fn.input "Command line args:"
              vim.cmd("CMakeLaunchArgs " .. args)
            end,
            "CMake launch args",
          },
          ["<C-b>"] = { "<cmd> CMakeBuild <CR>", "CMake build" },
          ["<leader>cr"] = { "<cmd> CMakeRun <CR>", "CMake run" },
          ["<C-r>"] = { "<cmd> CMakeRun <CR>", "CMake run" },
          ["<leader>cl"] = { "<cmd> CMakeSelectLaunchTarget <CR>", "CMake select launch target" },
          ["<leader>cqb"] = { "<cmd> CMakeQuickBuild <CR>", "CMake quick build" },
          ["<leader>cqd"] = { "<cmd> CMakeQuickDebug <CR>", "CMake quick debug" },
          ["<leader>cqr"] = { "<cmd> CMakeQuickRun <CR>", "CMake quick run" },
          ["<leader>cff"] = { "<cmd> Telescope cmake_tools <CR>", "Find cmake files" },
          ["<leader>cft"] = { "<cmd> CMakeShowTargetFiles <CR>", "Find cmake target files" },
          ["<leader>cct"] = { "<cmd> CMakeTargetSettings <CR>", "cmake target settings" },
          ["<leader>ccs"] = { "<cmd> CMakeSettings <CR>", "cmake settings" },
        },
      },
    }
  end,
}
