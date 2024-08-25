return {
  'hfn92/dissassembly.nvim',
  -- dir = "/home/fab/Work/nvim/dissassembly.nvim/",
  -- dev = true,
  cmd = { 'DisassembleFunction', 'DisassembleFile' },
  -- on cfopen?
  config = function()
    require('disassembly').setup {
      build_directory = function()
        local cmake = require 'cmake-tools'
        return cmake.get_config().build_directory:expand()
      end,
      compile_commands_path = function()
        local cmake = require 'cmake-tools'
        return cmake.get_config().build_directory:expand()
      end,
    }
  end,
}
