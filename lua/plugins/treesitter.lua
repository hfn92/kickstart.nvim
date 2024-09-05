return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
  config = function(_, opts)
    pcall(function() end)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    --

    local Path = require "plenary.path"

    if Path:new(vim.uv.cwd() .. "/tools/after"):exists() then
      vim.opt.runtimepath:append(vim.uv.cwd() .. "/tools/after")
    end

    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.lua = {
      -- This is where we load our custom queries
      queries = {
        -- The language
        lua = {
          -- Load the custom highlight query
          highlight = vim.uv.cwd() .. "/tools/queries/glsl.highlights.scm",
          -- vim.fn.stdpath "config" .. "/my-queries/lua/highlights.scm",
          -- Load the custom injection query
          -- injections = vim.fn.stdpath "config" .. "/my-queries/lua/injections.scm",
        },
      },
    }
  end,
}
