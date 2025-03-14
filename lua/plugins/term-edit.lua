return {
  "chomosuke/term-edit.nvim",
  event = "TermOpen",
  config = function()
    require("term-edit").setup {
      -- Mandatory option:
      -- Set this to a lua pattern that would match the end of your prompt.
      -- Or a table of multiple lua patterns where at least one would match the
      -- end of your prompt at any given time.
      -- For most bash/zsh user this is '%$ '.
      -- For most powershell/fish user this is '> '.
      -- For most windows cmd user this is '>'.
      prompt_end = "%$ ",
      -- How to write lua patterns: https://www.lua.org/pil/20.2.html
    }
  end,
}
