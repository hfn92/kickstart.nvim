return {
  ui = {
    theme = 'fab',
    hl_override = {
      St_gitIcons = { fg = '#6B6D6E' },
      CursorLine = { bg = '#2a2b2b' },
      DiffAdd = { fg = 'NONE', bg = '#2D382B' },
      GitSignsAdd = { fg = 'NONE', bg = '#FF382B' },
      DiffText = { fg = 'NONE', bg = '#542F2F' },
      DiffDelete = { fg = '#542F2F', bg = '#2a2b2b' },
      DiffChange = { fg = 'NONE', bg = 'NONE' },
      Search = { fg = '#2a2b2b', bg = '#97B77B' },
      ColorColumn = { bg = '#3B3C3C' },
      -- ['@ibl.scope.underline.1'] = { bg = 'NONE', fg = 'NONE' },
      ['@ibl.scope.underline.1'] = { bg = '#FFFFFF', fg = '#FFAAAA' },
    },
    statusline = {
      theme = 'default', -- default/vscode/vscode_colored/minimal
      -- default = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
      modules = {
        lsp_msg = function()
          local cmake = require 'cmake-tools'
          local type = cmake.get_build_type()
          local run = cmake.get_launch_target()
          local tgt = cmake.get_build_target()
          local args = cmake.get_launch_args()
          local preset = cmake.get_configure_preset()
          arg = ''
          if args ~= nil then
            for _, v in ipairs(args) do
              arg = arg .. v
            end
          end

          type = preset and preset or type

          local recordig = ''

          if vim.fn.reg_recording() and vim.fn.reg_recording() ~= '' then
            recordig = '%#DiagnosticUnnecessary# RECORDING MACRO [' .. vim.fn.reg_recording() .. ']'
          end

          local str = recordig
            .. '%#St_gitIcons#'
            .. '   ['
            .. (type and type or 'None')
            .. ']'
            .. '   ['
            .. (tgt and tgt or 'None')
            .. ']'
            .. '   ['
            .. (run and run or 'None')
            .. ']'
            .. '   <'
            .. arg
            .. '>'
          return str
        end,
      },
    },
  },
}
