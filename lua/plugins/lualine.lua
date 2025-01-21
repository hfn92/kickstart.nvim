local clr_base = {
  background = "#333436",
}

local colors = {
  black = "#282828",
  white = "#c5c8c2",
  red = "#fb4934",
  green = "#b8bb26",
  blue = "#83a598",
  yellow = "#fe8019",
  gray = "#a89984",
  darkgray = clr_base.background,
  lightgray = "#00FF00",
  inactivegray = "#0000FF",
  background = "#333436",
  bg2 = "#373b41",
  text = "#c5c8c2",
  normal = "#728da8",
}

local b = { bg = colors.bg2, fg = colors.text }
local c = { bg = colors.background, fg = "#6b6d6e" }
local y = { bg = colors.background, fg = "#728da8" }
local z = { bg = colors.background, fg = "#a4b595" }

local theme = {
  normal = {
    a = { bg = colors.normal, fg = colors.black, gui = "bold" },
    z = { bg = colors.normal, fg = colors.black },
  },
  insert = {
    a = { bg = "#b290ac", fg = colors.black, gui = "bold" },
  },
  visual = {
    a = { bg = "#70c0b1", fg = colors.black, gui = "bold" },
  },
  replace = {
    a = { bg = "#de935f", fg = colors.black, gui = "bold" },
  },
  command = {
    a = { bg = "#a4b595", fg = colors.black, gui = "bold" },
  },
  inactive = {
    a = { bg = colors.darkgray, fg = colors.gray },
  },
}

for _, value in pairs(theme) do
  value.b = b
  value.c = c
  value.y = y
  value.z = z
end

local separators = {
  default = { left = "", right = "" },
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
  arrow = { left = "", right = "" },
}

local stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

local function lsp_status()
  if rawget(vim, "lsp") then
    local ignore = {
      ["null-ls"] = true,
      ["copilot"] = true,
    }
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.attached_buffers[stbufnr()] and not ignore[client.name] then
        return (vim.o.columns > 100 and "   LSP ~ " .. client.name .. "") or "   LSP"
      end
    end
  end

  return ""
end

local function macro_status()
  local recordig = ""

  if vim.fn.reg_recording() and vim.fn.reg_recording() ~= "" then
    recordig = "%#LuaLineCwdIcon2# RECORDING MACRO [" .. vim.fn.reg_recording() .. "]"
  end

  return recordig
end

local function cmake_status()
  local cmake = require "cmake-tools"
  local type = cmake.get_build_type()
  local run = cmake.get_launch_target()
  local tgt = cmake.get_build_target()
  local args = cmake.get_launch_args()
  local preset = cmake.get_configure_preset()
  arg = ""
  if args ~= nil then
    for _, v in ipairs(args) do
      arg = arg .. v
    end
  end

  type = preset and preset or type

  local str = " ["
    .. (type and type or "None")
    .. "]"
    .. "   ["
    .. (tgt and tgt or "None")
    .. "]"
    .. "   ["
    .. (run and run or "None")
    .. "]"
    .. "   <"
    .. arg
    .. ">"
  return str
end
return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  config = function()
    local my_filename = require("lualine.components.filename"):extend()
    my_filename.apply_icon = require("lualine.components.filetype").apply_icon
    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },

        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 300,
          tabline = 300,
          winbar = 300,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { my_filename, symbols = {
            modified = " ●",
          } },
        },
        lualine_c = {
          function()
            if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
              return ""
            end

            local git_status = vim.b[stbufnr()].gitsigns_status_dict

            local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
            local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
            local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
            local branch_name = " " .. git_status.head

            return " " .. branch_name .. added .. changed .. removed
          end,
        },
        lualine_x = {
          -- 'encoding', 'fileformat', 'filetype',
          macro_status,
          cmake_status,
          "%=",
        },
        lualine_y = {
          "diagnostics",
          lsp_status,
          -- function()
          --   return "%#LuaLineCwdIcon2#" .. "%#LuaLineCwdIcon#󰉋"
          -- end,
          -- function()
          --   local name = vim.loop.cwd()
          --   if not name then
          --     return ""
          --   end
          --   name = "%#LuaLineY#" .. (name:match "([^/\\]+)[/\\]*$" or name) .. " "
          --   -- return (vim.o.columns > 85 and ('%#St_cwd_sep#' .. sep_l .. icon .. name)) or ''
          --   return (vim.o.columns > 85 and name) or ""
          -- end,
        },
        lualine_z = {
          -- "progress",
          {
            "tabs",
            show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
            mode = 0,
            symbols = {
              modified = " ●",
            },
            tabs_color = {
              -- Same values as the general color option can be used here.
              active = "BufferLineTabSelected", -- Color for active tab.
              inactive = "BufferLineTab", -- Color for inactive tab.
            },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      -- tabline = {
      --   lualine_a = {},
      --   lualine_b = { 'branch' },
      --   lualine_c = { 'filename' },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = { 'tabs' },
      -- },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
