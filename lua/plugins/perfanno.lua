function RunPerfCacheMisses()
  local cmake = require "cmake-tools"
  -- perf stat -e cycles,instructions,cache-references,cache-misses,bus-cycles
  -- /usr/bin/perf record -e cpu-cycles,cache-misses,branch-misses --call-graph dwarf,4096 -F 250 -o - -- /home/fab/Work/games/endtower/build_RelWithDebInfo/Game/Game PhysicsTest
  cmake.run {
    wrap_call = {
      "perf",
      "record",
      "-e",
      "cpu-cycles,branch-misses,cache-misses",
      "--call-graph",
      "dwarf,4096",
      "-F",
      "250",
    },
  }
end

function RunPerf()
  local cmake = require "cmake-tools"
  cmake.run { wrap_call = { "perf", "record", "--call-graph", "dwarf" } }
end

function AnalyzePerf()
  local cmake = require "cmake-tools"
  local target = cmake.get_launch_target()

  cmake.get_cmake_launch_targets(function(targets_res)
    if targets_res == nil then
      vim.cmd "CMakeGenerate"
      if targets_res == nil then
        return
      end
    end
    local targets, targetPaths = targets_res.data.targets, targets_res.data.abs_paths
    for idx, itarget in ipairs(targets) do
      if itarget == target then
        local target_dir = vim.fn.fnamemodify(targetPaths[idx], ":h")
        local perf = require "perfanno"
        perf.load_perf_callgraph { fargs = { target_dir .. "/perf.data" } }
      end
    end
  end)
end

return {
  -- "t-troebst/perfanno.nvim",
  "hfn92/perfanno.nvim",
  keys = "<leader>p",
  config = function()
    local util = require "perfanno.util"
    local bgcolor = vim.fn.synIDattr(vim.fn.hlID "Normal", "bg", "gui")
    require("perfanno").setup {
      -- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300"
      line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
      vt_highlight = util.make_fg_highlight "#CC3300",

      -- Automatically annotate files after :PerfLoadFlat and :PerfLoadCallGraph
      annotate_after_load = true,
      -- Automatically annotate newly opened buffers if information is available
      annotate_on_open = true,

      formats = {
        { percent = true, format = "%.2f%%", minimum = 0.5 },
        { percent = true, format = "%.2f%%", minimum = 0.1 },
        { percent = false, format = "%d", minimum = 1 },
      },

      get_path_callback = function()
        local cmake = require "cmake-tools"
        local target = cmake.get_launch_target()
        local res = ""
        cmake.get_cmake_launch_targets(function(targets_res)
          if targets_res == nil then
            vim.cmd "CMakeGenerate"
            if targets_res == nil then
              return
            end
          end
          local targets, targetPaths = targets_res.data.targets, targets_res.data.abs_paths
          for idx, itarget in ipairs(targets) do
            if itarget == target then
              res = vim.fn.fnamemodify(targetPaths[idx], ":h") .. "/perf.data"
            end
          end
        end)
        return res
      end,

      SetKeyBinds {
        n = {
          ["<leader>pr"] = { [[<cmd>lua RunPerf()<CR>]], "Run perf" },
          ["<leader>pa"] = { [[<cmd>lua AnalyzePerf()<CR>]], "Analyze Perf" },
          ["<leader>po"] = { [[<cmd>PerfToggleAnnotations<CR>]], "Toggle Perf" },
          ["<leader>pl"] = { [[<cmd>PerfHottestLines<CR>]], "Hottest Lines" },
          ["<leader>ps"] = { [[<cmd>PerfHottestSymbols<CR>]], "Hottest Symbols" },
          ["<leader>pf"] = { [[<cmd>PerfHottestCallersFunction<CR>]], "Hottest Callers" },
        },
      },
    }
  end,
  cmd = "PerfLoadCallGraph",
}
