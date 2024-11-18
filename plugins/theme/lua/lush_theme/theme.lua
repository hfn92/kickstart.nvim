--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

-- This is a starter colorscheme for use with Lush,
-- for usage guides, see :h lush or :LushRunTutorial

--
-- Note: Because this is a lua file, vim will append it to the runtime,
--       which means you can require(...) it in other lua code (this is useful),
--       but you should also take care not to conflict with other libraries.
--
--       (This is a lua quirk, as it has somewhat poor support for namespacing.)
--
--       Basically, name your file,
--
--       "super_theme/lua/lush_theme/super_theme_dark.lua",
--
--       not,
--
--       "super_theme/lua/dark.lua".
--
--       With that caveat out of the way...
--

-- Enable lush.ify on this file, run:
--
--  `:Lushify`
--
--  or
--
--  `:lua require('lush').ify()`

local lush = require "lush"
local hsl = lush.hsl


-- stylua: ignore start
local clr = {
  white         = '#C5C8C2',
  text          = '#D6CF9A',
  text2         = '#D6BB9A',
  pink          = '#ff9ca3',
  red           = '#FF8080',
  red_darker    = '#CC6666',
  red_darker2   = '#542F2F',
  macro         = '#D982CE',
  keyword       = '#9acfd6',
  orange        = '#D7bd8d',
  orange_darker = '#de935f',
  test          = '#FF0000',
  red_fade      = '#965758',
  str           = '#D69545',
  green_light   = '#a4b595',
  green         = '#97b77b',
  green_darkest = '#2D382B',

  yellow        = '#d7bd8d',
  bg_highlight  = "#8a7f2c",

  bg_darker2    = '#232527',

  bg_darker     = '#2a2b2b',
  bg_slightly_darker     = '#2c2d2e',
  bg            = '#2E2F30', -- bg
  bg_light      = '#3b3c3c',
  bg_lighter    = '#3D3E40', -- for lines like vertsplit
  grey          = '#6B6D6E', -- line number
  grey_fg       = '#A8ABB0', -- comments
  grey_light    = '#b4bbc8',

  blue_darker   = '#6f8dab',
}
-- stylua: ignore end

-- LSP/Linters mistakenly show `undefined global` errors in the spec, they may
-- support an annotation like the following. Consult your server documentation.
---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
  local sym = injected_functions.sym

  local result = {
    -- The following are the Neovim (as of 0.8.0-dev+100-g371dfb174) highlight
    -- groups, mostly used for styling UI elements.
    -- Comment them out and add your own properties to override the defaults.
    -- An empty definition `{}` will clear all styling, leaving elements looking
    -- like the 'Normal' group.
    -- To be able to link to a group, it must already be defined, so you may have
    -- to reorder items as you go.
    --
    -- See :h highlight-groups
    --
    Normal { fg = clr.text, bg = clr.bg }, -- Normal text
    ColorColumn { bg = clr.bg_light }, -- Columns set with 'colorcolumn'
    -- Conceal        { }, -- Placeholder characters substituted for concealed text (see 'conceallevel')
    -- Cursor {}, -- Character under the cursor
    -- CurSearch      { }, -- Highlighting a search pattern under the cursor (see 'hlsearch')
    -- lCursor        { }, -- Character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM       { }, -- Like Cursor, but used when in IME mode |CursorIM|
    -- CursorColumn { fg = clr.red }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine { bg = clr.bg_darker }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory { Normal }, -- Directory names (and other special names in listings)
    DiffAdd { bg = clr.green_darkest }, -- Diff mode: Added line |diff.txt|
    DiffChange {}, -- Diff mode: Changed line |diff.txt|
    DiffDelete { fg = clr.red_darker2, bg = clr.bg_darker }, -- Diff mode: Deleted line |diff.txt|
    DiffText { fg = "NONE", bg = clr.red_darker2 }, -- Diff mode: Changed text within a changed line |diff.txt|
    sym "@diff.plus" { DiffAdd },
    -- sym "@diff.delta" { fg = clr.red },
    sym "@diff.minus" { DiffText },

    -- EndOfBuffer    { }, -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
    -- TermCursor     { }, -- Cursor in a focused terminal
    -- TermCursorNC   { }, -- Cursor in an unfocused terminal
    -- ErrorMsg       { }, -- Error messages on the command line
    -- VertSplit      { }, -- Column separating vertically split windows
    Folded { bg = "#232527", fg = "#676e7b" },
    -- FoldColumn     { }, -- 'foldcolumn'
    -- SignColumn     { }, -- Column where |signs| are displayed
    -- IncSearch { bg = clr.red }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- Substitute     { }, -- |:substitute| replacement text highlighting
    LineNr { fg = clr.grey }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    -- LineNrAbove    { }, -- Line number for when the 'relativenumber' option is set, above the cursor line
    -- LineNrBelow    { }, -- Line number for when the 'relativenumber' option is set, below the cursor line
    CursorLineNr { fg = clr.white }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    -- CursorLineFold { }, -- Like FoldColumn when 'cursorline' is set for the cursor line
    -- CursorLineSign { }, -- Like SignColumn when 'cursorline' is set for the cursor line
    -- MatchParen     { }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    -- ModeMsg { fg = "#0000FF" }, -- 'showmode' message (e.g., "-- INSERT -- ")
    -- MsgArea        { }, -- Area for messages and cmdline
    -- MsgSeparator   { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- MoreMsg        { }, -- |more-prompt|
    NonText { fg = clr.text2 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.

    NormalFloat { bg = clr.bg_darker }, -- Normal text in floating windows.
    FloatBorder { fg = clr.blue_darker },
    -- FloatTitle { TelescopePreviewTitle }, -- Title of floating windows.
    FloatTitle { Normal }, -- Title of floating windows.
    -- NormalNC       { }, -- normal text in non-current windows
    Pmenu { bg = clr.bg_darker2 }, -- Popup menu: Normal item.
    PmenuSel { bg = clr.bg_light }, -- Popup menu: Selected item.
    -- PmenuKind      { }, -- Popup menu: Normal item "kind"
    -- PmenuKindSel   { }, -- Popup menu: Selected item "kind"
    -- PmenuExtra     { }, -- Popup menu: Normal item "extra text"
    -- PmenuExtraSel  { }, -- Popup menu: Selected item "extra text"
    -- PmenuSbar      { }, -- Popup menu: Scrollbar.
    -- PmenuThumb     { }, -- Popup menu: Thumb of the scrollbar.
    -- Question       { }, -- |hit-enter| prompt and yes/no questions
    Search { bg = clr.bg_highlight }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    -- SpecialKey     { }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad       { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    -- SpellCap       { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal     { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare      { }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
    -- StatusLine     { }, -- Status line of current window
    -- StatusLineNC   { }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    -- TabLine        { }, -- Tab pages line, not active tab page label
    -- TabLineFill    { }, -- Tab pages line, where there are no labels
    -- TabLineSel     { }, -- Tab pages line, active tab page label
    Title { Normal }, -- Titles for output from ":set all", ":autocmd" etc.
    Visual { bg = "#1d545c" }, -- Visual         xxx guibg=#1d545c
    -- VisualNOS      { }, -- Visual mode selection when vim is "Not Owning the Selection".
    -- WarningMsg     { }, -- Warning messages
    -- Whitespace     { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    Winseparator { fg = clr.bg_lighter }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
    -- WildMenu       { }, -- Current match in 'wildmenu' completion
    -- WinBar         { }, -- Window bar of current window
    -- WinBarNC       { }, -- Window bar of not-current windows

    QuickFixLine { bg = clr.bg_light }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    qfFileName { fg = clr.text2 },
    qfLineNr { fg = clr.keyword },

    -- Common vim syntax groups used for all kinds of code and markup.
    -- Commented-out groups should chain up to their preferred (*) group
    -- by default.
    --
    -- See :h group-name
    --
    -- Uncomment and edit if you want more specific syntax highlighting.

    Comment { fg = "#9b9ea4" }, -- Any comment

    -- Constant       { }, -- (*) Any constant
    String { fg = clr.str }, --   A string constant: "this is a string"
    -- Character      { }, --   A character constant: 'c', '\n'
    Number { fg = clr.orange_darker }, --   A number constant: 234, 0xff
    Boolean { Number }, --   A boolean constant: TRUE, false
    -- Float          { }, --   A floating point constant: 2.3e10

    -- Identifier     { }, -- (*) Any variable name
    -- Function       { }, --   Function name (also: methods for classes)

    Statement { fg = clr.red }, -- (*) Any statement
    Conditional { Statement }, --   if, then, else, endif, switch, etc.
    Repeat { fg = clr.keyword }, --   for, do, while, etc.
    -- Label          { }, --   case, default, etc.
    Operator { Normal }, --   "sizeof", "+", "*", etc.
    -- Keyword        { }, --   any other keyword
    -- Exception      { }, --   try, catch, throw

    -- PreProc        { }, -- (*) Generic Preprocessor
    -- Include        { }, --   Preprocessor #include
    -- Define         { }, --   Preprocessor #define
    -- Macro          { }, --   Same as Define
    -- PreCondit      { }, --   Preprocessor #if, #else, #endif, etc.

    -- Type           { }, -- (*) int, long, char, etc.
    -- StorageClass   { }, --   static, register, volatile, etc.
    -- Structure      { }, --   struct, union, enum, etc.
    -- Typedef        { }, --   A typedef

    Special { fg = clr.keyword }, -- (*) Any special symbol
    -- SpecialChar    { }, --   Special character in a constant
    -- Tag            { }, --   You can use CTRL-] on this
    Delimiter { fg = clr.text }, --   Character that needs attention
    -- SpecialComment { }, --   Special things inside a comment (e.g. '\n')
    -- Debug          { }, --   Debugging statements

    -- Underlined     { gui = "underline" }, -- Text that stands out, HTML links
    -- Ignore         { }, -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
    -- Error          { }, -- Any erroneous construct
    -- Todo           { }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client and diagnostic system. Some
    -- other LSP clients may use these groups, or use their own. Consult your
    -- LSP client's documentation.

    -- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!
    --
    -- LspReferenceText            { } , -- Used for highlighting "text" references
    -- LspReferenceRead            { } , -- Used for highlighting "read" references
    -- LspReferenceWrite           { } , -- Used for highlighting "write" references
    -- LspCodeLens                 { } , -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
    -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

    -- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!
    --
    DiagnosticError { fg = clr.red_darker }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticWarn { fg = clr.orange }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticInfo { fg = clr.keyword }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticHint { fg = clr.grey_light },
    -- DiagnosticOk {}, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    -- DiagnosticVirtualTextError { } , -- Used for "Error" diagnostic virtual text.
    -- DiagnosticVirtualTextWarn  { } , -- Used for "Warn" diagnostic virtual text.
    -- DiagnosticVirtualTextInfo  { } , -- Used for "Info" diagnostic virtual text.
    -- DiagnosticVirtualTextHint  { } , -- Used for "Hint" diagnostic virtual text.
    -- DiagnosticVirtualTextOk    { } , -- Used for "Ok" diagnostic virtual text.
    -- DiagnosticUnderlineError   { } , -- Used to underline "Error" diagnostics.
    -- DiagnosticUnderlineWarn    { } , -- Used to underline "Warn" diagnostics.
    -- DiagnosticUnderlineInfo    { } , -- Used to underline "Info" diagnostics.
    -- DiagnosticUnderlineHint    { } , -- Used to underline "Hint" diagnostics.
    -- DiagnosticUnderlineOk      { } , -- Used to underline "Ok" diagnostics.
    -- DiagnosticFloatingError    { } , -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
    -- DiagnosticFloatingWarn     { } , -- Used to color "Warn" diagnostic messages in diagnostics float.
    -- DiagnosticFloatingInfo     { } , -- Used to color "Info" diagnostic messages in diagnostics float.
    -- DiagnosticFloatingHint     { } , -- Used to color "Hint" diagnostic messages in diagnostics float.
    -- DiagnosticFloatingOk       { } , -- Used to color "Ok" diagnostic messages in diagnostics float.
    -- DiagnosticSignError        { } , -- Used for "Error" signs in sign column.
    -- DiagnosticSignWarn         { } , -- Used for "Warn" signs in sign column.
    -- DiagnosticSignInfo         { } , -- Used for "Info" signs in sign column.
    -- DiagnosticSignHint         { } , -- Used for "Hint" signs in sign column.
    -- DiagnosticSignOk           { } , -- Used for "Ok" signs in sign column.
    DiagnosticUnnecessary { fg = clr.red }, -- DiagnosticUnnecessary xxx ctermbg=0 guifg=#ff8080

    -- Tree-Sitter syntax groups.
    --
    -- See :h treesitter-highlight-groups, some groups may not be listed,
    -- submit a PR fix to lush-template!
    --
    -- Tree-Sitter groups are defined with an "@" symbol, which must be
    -- specially handled to be valid lua code, we do this via the special
    -- sym function. The following are all valid ways to call the sym function,
    -- for more details see https://www.lua.org/pil/5.html
    --
    -- sym("@text.literal")
    -- sym('@text.literal')
    -- sym"@text.literal"
    -- sym'@text.literal'
    --
    -- For more information see https://github.com/rktjmp/lush.nvim/issues/109

    -- sym"@text.literal"      { }, -- Comment
    -- sym"@text.reference"    { }, -- Identifier
    -- sym"@text.title"        { }, -- Title
    -- sym"@text.uri"          { }, -- Underlined
    -- sym"@text.underline"    { }, -- Underlined
    -- sym"@text.todo"         { }, -- Todo
    -- sym"@comment"           { }, -- Comment
    -- sym"@punctuation"       { }, -- Delimiter
    -- sym"@constant"          { }, -- Constant
    -- sym"@constant.builtin"  { }, -- Special
    -- sym"@constant.macro"    { }, -- Define
    -- sym"@define"            { }, -- Define
    -- sym"@macro"             { }, -- Macro
    -- sym"@string"            { }, -- String
    -- sym"@string.escape"     { }, -- SpecialChar
    -- sym"@string.special"    { }, -- SpecialChar
    -- sym"@character"         { }, -- Character
    -- sym"@character.special" { }, -- SpecialChar
    -- sym"@number"            { }, -- Number
    -- sym"@boolean"           { }, -- Boolean
    -- sym"@float"             { }, -- Float
    -- sym"@function"          { }, -- Function
    -- sym"@function.builtin"  { }, -- Special
    -- sym"@function.macro"    { }, -- Macro
    -- sym"@parameter"         { }, -- Identifier
    -- sym"@method"            { }, -- Function
    -- sym"@field"             { }, -- Identifier
    -- sym"@property"          { }, -- Identifier
    -- sym"@constructor"       { }, -- Special
    -- sym"@conditional"       { }, -- Conditional
    -- sym"@repeat"            { }, -- Repeat
    -- sym"@label"             { }, -- Label
    -- sym"@operator"          { }, -- Operator
    -- sym"@keyword"           { }, -- Keyword
    -- sym"@exception"         { }, -- Exception
    -- sym"@variable"          { }, -- Identifier
    -- sym"@type"              { }, -- Type
    -- sym"@type.definition"   { }, -- Typedef
    -- sym"@storageclass"      { }, -- StorageClass
    -- sym"@structure"         { }, -- Structure
    -- sym"@namespace"         { }, -- Identifier
    -- sym"@include"           { }, -- Include
    -- sym"@preproc"           { }, -- PreProc
    -- sym"@debug"             { }, -- Debug
    -- sym"@tag"               { }, -- Tag

    --- Diagnostics

    -- stylua: ignore start
    TelescopeBorder            { fg = clr.bg_darker,  bg = clr.bg_darker   },
    TelescopePromptBorder      { fg = clr.bg_darker2, bg = clr.bg_darker2  },
    TelescopePromptNormal      { fg = clr.white,      bg = clr.bg_darker2  },
    TelescopeResultsTitle      { fg = clr.bg_darker,  bg = clr.bg_darker   },
    TelescopePromptPrefix      { fg = clr.red_darker, bg = clr.bg_darker2  },
    TelescopeNormal            { bg = clr.bg_darker                        },
    TelescopePreviewTitle      { fg = clr.bg,         bg = clr.green_light },
    TelescopePromptTitle       { fg = clr.bg,         bg = clr.red_darker  },
    TelescopeSelection         { bg = clr.bg_darker2, fg = clr.white       },
    TelescopeResultsDiffAdd    { fg = clr.green                            },
    TelescopeResultsDiffChange { fg = clr.yellow                           },
    TelescopeResultsDiffDelete { fg = clr.red_darker                       },
    TelescopeMatching          { Search                                    },
    -- stylua: ignore end

    -- stylua: ignore start
    WhichKey          { fg = clr.blue_darker },
    WhichKeyDesc      { fg = clr.red_darker  },
    WhichKeyGroup     { fg = clr.green_light },
    WhichKeyValue     { fg = clr.green_light },
    WhichKeySeparator { fg = '#676e7b'       },
    -- stylua: ignore end

    ------- CODE ----
    -- stylua: ignore start
    Keyword    { fg = clr.keyword },
    Constant   { Normal           },
    Function   { Normal           },
    Identifier { Normal           },
    Type       { fg = clr.red     },
    MatchParen { Search           },

    sym'@String'         { fg = clr.str     },
    sym'@variable'       { Normal           },
    sym'@type.builtin'   { fg = clr.red     },
    sym'@keyword.import' { Normal           },
    sym'@keyword.repeat' { fg = clr.keyword },
    sym'@string.escape'  { fg = clr.yellow  },

    -- cpp
    sym'@namespace.cpp'                { fg = clr.text     },
    sym'@type.qualifier.cpp'           { fg = clr.keyword  },
    sym'@property.cpp'                 { fg = clr.text     },
    sym'@parameter.cpp'                { fg = clr.text     },
    sym'@constant.cpp'                 { fg = clr.text     },
    sym'@attribute.cpp'                { fg = clr.text2    },
    sym'@Field.cpp'                    { fg = clr.text     },
    sym'@constructor.cpp'              { fg = clr.text     },
    sym'@variable.builtin.cpp'         { fg = clr.keyword  },
    sym'@keyword.return.cpp'           { fg = clr.keyword  },
    sym'@keyword.cpp'                  { fg = clr.keyword  },
    sym'@conditional.cpp'              { fg = clr.keyword  },
    sym'@repeat.cpp'                   { fg = clr.keyword  },
    sym'@variable.cpp'                 { fg = clr.text2    },
    sym'@operator.cpp'                 { fg = clr.text2    },
    sym'@character.cpp'                { fg = clr.str      },
    sym'Structure'                     { fg = clr.red      },
    sym'@lsp.type.class.cpp'           { fg = clr.red      },
    sym'@lsp.typemod.enum.deduced.cpp' { fg = clr.red      },
    sym'@lsp.type.namespace.cpp'       { fg = clr.red_fade },
    sym'@lsp.type.macro.cpp'           { fg = clr.macro    },

    ---- LUA ---
    sym'@lsp.type.class.lua'                { fg = clr.text2      },
    sym'@lsp.type.type.lua'                 { fg = clr.text2      },
    -- sym'@lsp.typemod.keyword.documentation' { fg = clr.grey_fg  },
    sym'@lsp.typemod.event.static'          { fg = clr.text    },



    sym"@function.builtin.cmake" { fg = clr.text2 },
    sym"@constant.cmake" { fg = clr.red },

    sym"@variable.builtin.glsl" { fg = clr.orange_darker },


    -- stylua: ignore end

    ------- CODE ----
    -- stylua: ignore start

    DapBreakpoint               { fg = '#993939'   },
    DapUIType                   { fg = clr.grey    },
    DapUIThread                 { fg = clr.grey    },
    DapStopped                  { fg = clr.green   },
    DapUISource                 { fg = clr.green   },
    DapUIDecoration             { fg = clr.green   },
    DapUIBreakpointsInfo        { fg = clr.green   },
    DapUIBreakpointsCurrentLine { fg = clr.green   },
    DapUIPlayPause              { fg = clr.green   },
    DapUIRestart                { fg = clr.green   },
    DapUILineNumber             { Comment          },
    DapUIScope                  { Comment          },
    DapUIBreakpointsPath        { Comment          },
    DapUIStoppedThread          { Comment          },
    DapUIVariable               { Comment          },
    DapUIWatchesValue           { Comment          },
    DapLogPoint                 { fg = clr.keyword },
    DapUIStepOver               { fg = clr.keyword },
    DapUIStepInto               { fg = clr.keyword },
    DapUIStepBack               { fg = clr.keyword },
    DapUIStepOut                { fg = clr.keyword },
    DapUIWatchesEmpty           { fg = clr.keyword },
    DapUIModifiedValue          { fg = clr.red     },
    DapUIStop                   { fg = clr.red     },
    DapUIWatchesError           { fg = clr.red     },
    DapUI                       { fg = clr.red     },
    NvimDapVirtualTextChanged   { fg = clr.red     },
    NvimDapVirtualText          { Comment          },

    --- GitSigns ---
    GitSignsAdd { fg = clr.blue_darker },
    GitSignsStagedAdd { fg = clr.green_light },
    GitSignsDelete { fg = clr.red_darker },
    GitSignsChange { ctermbg = 0, fg = '#676e7b', bg = '#2E2F30' },
    GitSignsDeleteVirtLn { ctermbg = 0, fg = 'None', bg = '#542F2F' },

    LuaLineCwdIcon { bg = '#cc6666', fg = '#2d2f31' },
    LuaLineCwdIcon2 { fg = '#cc6666', bg = '#333436' },
    LuaLineY { bg = '#373b41', fg = clr.white },

    NoiceFormatEvent { NonText }, -- NoiceFormatEvent xxx links to NonText

    -- sym '@ibl.indent.char.1' { fg = clr.red }, -- @ibl.indent.char.1 xxx cterm=nocombine gui=nocombine
    -- sym '@ibl.whitespace.char.1' { fg = clr.red }, -- @ibl.whitespace.char.1 xxx cterm=nocombine gui=nocombine
    -- sym '@ibl.scope.char.1' { gui = 'nocombine', fg = '#4f5258' }, -- @ibl.scope.char.1 xxx cterm=nocombine gui=nocombine guifg=#4f5258
    -- sym '@ibl.scope.underline.1' { gui = 'underline', sp = '#4f5258' }, -- @ibl.scope.underline.1 xxx cterm=underline gui=underline guisp=#4f5258

    CmpPmenu                     { bg = '#2e2f30'                        },
    CmpBorder                    { fg = '#a8abb0'                        },
    CmpDoc                       { bg = '#2a2b2b'                        },
    CmpItemAbbr                  { fg = '#c5c8c2'                        },
    CmpItemKindTabNine           { fg = '#ff6e79'                        },
    CmpItemKindCodeium           { fg = '#a3b991'                        },
    CmpItemKindCopilot           { fg = '#a4b595'                        },
    CmpItemKindType              { fg = '#ff8080'                        },
    CmpItemKindStructure         { fg = '#9acfd6'                        },
    CmpItemKindIdentifier        { fg = '#d6cf9a'                        },
    CmpItemAbbrDeprecatedDefault { fg = 'nvimlightgrey4'                 },
    CmpItemAbbrMatch             { gui = 'bold', fg = '#6f8dab'          },
    CmpItemKindDefault           { fg = 'nvimlightcyan'                  },
    CmpItemKind                  { CmpItemKindDefault                    },
    CmpItemKindFunction          { fg = '#d6cf9a'                        },
    CmpItemKindUnit              { fg = '#9acfd6'                        },
    CmpItemKindFolder            { fg = '#ffffff'                        },
    CmpItemKindReference         { fg = '#d6cf9a'                        },
    CmpItemKindColor             { fg = '#c5c8c2'                        },
    CmpItemKindValue             { fg = '#70c0b1'                        },
    CmpItemKindSnippet           { fg = '#cc6666'                        },
    CmpItemKindInterface         { fg = '#a4b595'                        },
    CmpItemKindEnumMember        { fg = '#b4bbc8'                        },
    CmpItemKindFile              { fg = '#ffffff'                        },
    CmpItemKindEnum              { fg = '#6f8dab'                        },
    CmpItemKindKeyword           { fg = '#ffffff'                        },
    CmpItemKindClass             { fg = '#8abdb6'                        },
    CmpItemKindVariable          { fg = '#9acfd6'                        },
    CmpItemKindField             { fg = '#d6cf9a'                        },
    CmpItemKindProperty          { fg = '#d6cf9a'                        },
    CmpItemKindText              { fg = '#d69545'                        },
    CmpItemKindConstructor       { fg = '#6f8dab'                        },
    CmpItemKindConstant          { fg = '#de935f'                        },
    CmpItemKindEvent             { fg = '#d7bd8d'                        },
    CmpItemKindStruct            { fg = '#9acfd6'                        },
    CmpItemKindTypeParameter     { fg = '#d6cf9a'                        },
    CmpItemKindModule            { fg = '#ff8080'                        },
    CmpItemKindOperator          { fg = '#d6cf9a'                        },
    CmpItemKindMethod            { fg = '#d6cf9a'                        },
    CmpItemAbbrDeprecated        { gui = 'strikethrough', fg = '#808080' },
    CmpDocBorder                 { bg = '#2a2b2b', fg = '#2a2b2b'        },

    LspReferenceRead            { Search },
    LspReferenceText            { Search },
    LspReferenceWrite           { Search },
    LspSignatureActiveParameter { gui = 'underline|bold'         },

    DiffviewSecondary           { fg = clr.red                   },
    DiffviewFilePanelInsertions { TelescopeResultsDiffAdd        },
    DiffviewFilePanelDeletions  { TelescopeResultsDiffDelete     },
    DiffviewStatusAdded         { DiffviewFilePanelInsertions    },
    DiffviewStatusDeleted       { DiffviewFilePanelDeletions     },
    DiffviewStatusRenamed       { fg = clr.keyword               },
    DiffviewStatusModified      { fg = clr.text2                 },
    DiffviewFilePanelTitle      { fg = clr.white, gui = "bold"   },
    DiffviewFolderName          { fg = clr.text            },
    DiffviewFolderSign          { DiffviewFolderName             },


    IblIndent { fg = clr.bg_lighter },
    -- IblScopeChar { fg = clr.red },
    sym '@ibl.scope.underline.1' { gui = 'underline', sp = '#FF5258' },


    NoicePopupmenu          { Pmenu            },
    NoicePopup              { NormalFloat      },
    NoiceCmdlinePopup       { Normal           },
    NoiceCmdlinePopupBorder { fg = clr.grey_fg },
    NoiceCmdlinePopupTitle  { fg = clr.red     },
    NoiceCmdlinePrompt      { fg = clr.red     },
    NoiceCmdlineIcon        { fg = clr.grey_fg },
    NoiceFormatProgressDone { bg =  clr.green, fg = '#2a2b2b' },

    BufferLineSelected         { fg = clr.white },
    BufferLineNormal           { fg = clr.grey, bg = clr.bg},
    BufferLineBufferSelected   { BufferLineSelected },
    BufferLineBufferVisible    { BufferLineNormal, },
    BufferLineModifiedSelected { bg = "#2e2f30", fg = clr.orange },
    BufferLineModifiedVisible  { BufferLineModifiedSelected, bg = clr.bg},
    BufferLineModified         { BufferLineModifiedSelected, bg = clr.bg},

    BufferLineFill { bg = clr.bg, fg = "#9b9ea4" },
    -- BufferLineTab { bg = clr.green, fg = clr.green }, 
    BufferLineBackground { BufferLineNormal },

    BufferLineDuplicate          { BufferLineNormal,     fg = clr.grey    },
    BufferLineDuplicateVisible   { BufferLineNormal,     fg = clr.grey    },
    BufferLineDuplicateSelected  { BufferLineSelected,   fg = clr.grey    },
    BufferLineIndicatorSelected  { fg = clr.green_light, bg = clr.bg,     },
    BufferLineIndicatorVisible   { fg = clr.red, bg = clr.bg,     },
    BufferLineIndicator          { fg = clr.red, bg = clr.bg,     },
    BufferLineDevIconluaSelected { bg = clr.bg,          fg = "#51a0cf",  },
    BufferLineDevIconlua         { bg =clr.bg_darker2,   fg = clr.grey    },
    BufferLineDevIconluaInactive {BufferLineDevIconlua                    },

    BufferLineTab { fg = "#9b9ea4", },
    BufferLineTabSelected { fg = clr.green_light, bg = "#2e2f30", gui = "underline" },

    MasonHighlightBlock     { bg = "#a4b595", fg = "#2e2f30" },
    MasonHighlightBlockBold { MasonHighlightBlock            },
    MasonHeaderSecondary    { MasonHighlightBlock            },
    MasonHighlight          { fg = "#6f8dab"                 },
    MasonHeader             { bg = "#cc6666", fg = "#2e2f30" },
    MasonMutedBlock         { bg = "#2d2f31", fg = "#676e7b" },
    MasonMuted              { fg = "#676e7b"                 },

    LazyReasonCmd     { fg = "#e4c180"                         },
    LazyProgressDone  { fg = "#a4b595"                         },
    LazyReasonImport  { fg = "#c5c8c2"                         },
    LazyReasonSource  { fg = "#70c0b1"                         },
    LazyReasonRuntime { fg = "#728da8"                         },
    LazyReasonStart   { fg = "#c5c8c2"                         },
    LazyReasonEvent   { fg = "#d7bd8d"                         },
    LazyCommitIssue   { fg = "#ff9ca3"                         },
    LazyTaskOutput    { fg = "#c5c8c2"                         },
    LazyReasonKeys    { fg = "#8abdb6"                         },
    LazyOperator      { fg = "#c5c8c2"                         },
    LazyReasonFt      { fg = "#b4bbc8"                         },
    LazySpecial       { fg = "#6f8dab"                         },
    LazyNoCond        { fg = "#cc6666"                         },
    LazyCommit        { fg = "#a4b595"                         },
    LazyUrl           { fg = "#d6cf9a"                         },
    LazyDir           { fg = "#d6cf9a"                         },
    LazyValue         { fg = "#8abdb6"                         },
    LazyReasonPlugin  { fg = "#cc6666"                         },
    LazyH2            { gui = "bold,underline", fg = "#cc6666" },
    LazyButton        { bg = "#2d2f31", fg = "#808794"         },
    LazyH1            { bg = "#a4b595", fg = "#2e2f30"         },

    TodoBgPERF        { bg = clr.red_darker2                 },
    TodoFgPERF        { bg = clr.red_darker2                 },

    TodoBgNOTE        { bg = clr.green_light,   fg = clr.bg_darker, gui = "bold"  },
    TodoFgNOTE        { fg = clr.green_light                  },


    sym'@markup.raw.block.markdown' { fg = clr.orange_darker },
    sym'@markup.raw.markdown_inline' { fg = clr.orange_darker },
    sym'@markup.heading.1.markdown' { bg = clr.bg_darker, fg = clr.keyword },
    sym'@markup.heading.2.markdown' { bg = clr.bg_darker, fg = clr.keyword },
    sym'@markup.heading.3.markdown' { bg = clr.bg_darker, fg = clr.keyword },
    sym'@markup.heading.4.markdown' { bg = clr.bg_darker, fg = clr.keyword },
    sym'@markup.heading.5.markdown' { bg = clr.bg_darker, fg = clr.keyword },
    sym'@text.title.1.marker.markdown'     {  fg = clr.keyword },
    sym'@text.title.2.marker.markdown'     {  fg = clr.keyword },
    sym'@text.title.3.marker.markdown'     {  fg = clr.keyword },
    sym'@text.title.4.marker.markdown'     {  fg = clr.keyword },
    sym'@text.title.5.marker.markdown'     {  fg = clr.keyword },
    sym'@text.title.1.markdown'            {  fg = clr.keyword },
    sym'@text.title.2.markdown'            {  fg = clr.keyword },
    sym'@text.title.3.markdown'            {  fg = clr.keyword },
    sym'@text.title.4.markdown'            {  fg = clr.keyword },
    sym'@text.title.5.markdown'            {  fg = clr.keyword },
    sym'@punctuation.special.markdown' { fg = clr.orange_darker },
    sym'@markup.list.markdown' { fg = clr.red_fade },

    -- RenderMarkdownDash                                          { LineNr },
    RenderMarkdownH1Bg                                          { bg = clr.bg_darker },
    RenderMarkdownH2Bg                                          { bg = clr.bg_darker },
    RenderMarkdownH3Bg                                          { bg = clr.bg_darker },
    RenderMarkdownH4Bg                                          { bg = clr.bg_darker },
    RenderMarkdownH5Bg                                          { bg = clr.bg_darker },
    RenderMarkdownH6Bg                                          { bg = clr.bg_darker },
    -- RenderMarkdownSign                                          { SignColumn },
    -- RenderMarkdownTableFill                                     { Conceal },
    RenderMarkdownCode                                          { bg = clr.bg_slightly_darker },
    -- sym"@markup.raw.block.markdown"                             { bg = "none" },
    -- sym '@ibl.scope.underline.1' { gui = 'underline', sp = '#FF5258' },
    RenderMarkdownBullet                                        { fg = clr.red_fade },
    -- -- RenderMarkdownTableRow                                      { Normal },
    -- -- RenderMarkdownInfo                                          { DiagnosticInfo },
    -- -- RenderMarkdownHint                                          { DiagnosticHint },
    -- -- RenderMarkdownSuccess                                       { DiagnosticOk },
    -- -- RenderMarkdownH5                                            { sym"@markup.heading.5.markdown" },
    -- -- RenderMarkdownH4                                            { sym"@markup.heading.4.markdown" },
    -- -- RenderMarkdownH3                                            { sym"@markup.heading.3.markdown" },
    -- -- RenderMarkdownH2                                            { sym"@markup.heading.2.markdown" },
    -- -- RenderMarkdownH1                                            { sym"@markup.heading.1.markdown" },
    -- -- RenderMarkdown_RenderMarkdownH1_RenderMarkdownSign          { fg="#9acfd6", },
    -- -- RenderMarkdown_RenderMarkdownH2_RenderMarkdownSign          { fg="#9acfd6", },
    -- -- RenderMarkdown_RenderMarkdownH3_RenderMarkdownSign          { fg="#9acfd6", },
    -- -- RenderMarkdown_RenderMarkdownH5_RenderMarkdownSign          { fg="#9acfd6", },
    -- -- RenderMarkdown_DevIconCpp_RenderMarkdownSign                { fg="#519aba", },
    -- RenderMarkdown_bgtofg_RenderMarkdownCode                    { fg = clr.red },
    -- --
  }
  -- stylua: ignore end

  -- print(vim)
  -- result = extend(result, code)
  return result
end)
--
-- Return our parsed theme for extension or use elsewhere.

-- local clrsx = require 'theme.colors2'
--
-- theme = lush.extends({ theme }).with(function(injected_functions)
--   local sym = injected_functions.sym
--   local res = {
--   }
--   return res
-- end)

-- theme = lush.extends({ theme }).with(function(injected_functions)
--   return require 'theme.code'(theme, injected_functions.sym)
-- end)

return lush(theme)
