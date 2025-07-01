local NAME_REGEX = "\\%([^/\\\\:\\*?<>'\"`\\|]\\)"
local PATH_REGEX =
  vim.regex(([[\%(\%(/PAT*[^/\\\\:\\*?<>\'"`\\| .~]\)\|\%(/\.\.\)\)*/\zePAT*$]]):gsub("PAT", NAME_REGEX))

local rip_grep_provider =
  -- 👇🏻👇🏻 add the ripgrep provider config below
  {
    module = "blink-ripgrep",
    name = "Ripgrep",
    score_offset = -100,
    -- the options below are optional, some default values are shown
    ---@module "blink-ripgrep"
    ---@type blink-ripgrep.Options
    opts = {
      -- For many options, see `rg --help` for an exact description of
      -- the values that ripgrep expects.

      -- the minimum length of the current word to start searching
      -- (if the word is shorter than this, the search will not start)
      prefix_min_len = 3,

      -- The number of lines to show around each match in the preview
      -- (documentation) window. For example, 5 means to show 5 lines
      -- before, then the match, and another 5 lines after the match.
      context_size = 5,

      -- The maximum file size of a file that ripgrep should include in
      -- its search. Useful when your project contains large files that
      -- might cause performance issues.
      -- Examples:
      -- "1024" (bytes by default), "200K", "1M", "1G", which will
      -- exclude files larger than that size.
      max_filesize = "1M",

      -- Specifies how to find the root of the project where the ripgrep
      -- search will start from. Accepts the same options as the marker
      -- given to `:h vim.fs.root()` which offers many possibilities for
      -- configuration. If none can be found, defaults to Neovim's cwd.
      --
      -- Examples:
      -- - ".git" (default)
      -- - { ".git", "package.json", ".root" }
      project_root_marker = ".git",

      -- Enable fallback to neovim cwd if project_root_marker is not
      -- found. Default: `true`, which means to use the cwd.
      project_root_fallback = true,

      -- The casing to use for the search in a format that ripgrep
      -- accepts. Defaults to "--ignore-case". See `rg --help` for all the
      -- available options ripgrep supports, but you can try
      -- "--case-sensitive" or "--smart-case".
      search_casing = "--ignore-case",

      -- (advanced) Any additional options you want to give to ripgrep.
      -- See `rg -h` for a list of all available options. Might be
      -- helpful in adjusting performance in specific situations.
      -- If you have an idea for a default, please open an issue!
      --
      -- Not everything will work (obviously).
      additional_rg_options = {},

      -- When a result is found for a file whose filetype does not have a
      -- treesitter parser installed, fall back to regex based highlighting
      -- that is bundled in Neovim.
      fallback_to_regex_highlighting = true,

      -- Absolute root paths where the rg command will not be executed.
      -- Usually you want to exclude paths using gitignore files or
      -- ripgrep specific ignore files, but this can be used to only
      -- ignore the paths in blink-ripgrep.nvim, maintaining the ability
      -- to use ripgrep for those paths on the command line. If you need
      -- to find out where the searches are executed, enable `debug` and
      -- look at `:messages`.
      ignore_paths = {},

      -- Any additional paths to search in, in addition to the project
      -- root. This can be useful if you want to include dictionary files
      -- (/usr/share/dict/words), framework documentation, or any other
      -- reference material that is not available within the project
      -- root.
      additional_paths = {},

      -- Keymaps to toggle features on/off. This can be used to alter
      -- the behavior of the plugin without restarting Neovim. Nothing
      -- is enabled by default. Requires folke/snacks.nvim.
      toggles = {
        -- The keymap to toggle the plugin on and off from blink
        -- completion results. Example: "<leader>tg"
        on_off = nil,
      },

      -- Features that are not yet stable and might change in the future.
      -- You can enable these to try them out beforehand, but be aware
      -- that they might change. Nothing is enabled by default.
      future_features = {
        backend = {
          -- The backend to use for searching. Defaults to "ripgrep".
          -- Available options:
          -- - "ripgrep", always use ripgrep
          -- - "gitgrep", always use git grep
          -- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
          --   ripgrep
          use = "ripgrep",
        },
      },

      -- Show debug information in `:messages` that can help in
      -- diagnosing issues with the plugin.
      debug = false,
    },
    -- (optional) customize how the results are displayed. Many options
    -- are available - make sure your lua LSP is set up so you get
    -- autocompletion help
    transform_items = function(_, items)
      for _, item in ipairs(items) do
        -- example: append a description to easily distinguish rg results
        item.labelDetails = {
          description = "(rg)",
        }
      end
      return items
    end,
  }

-- keymap = {
--   -- 👇🏻👇🏻 (optional) add a keymap to invoke the search manually
--   ["<c-g>"] = {
--     function()
--       -- invoke manually, requires blink >v0.8.0
--       require("blink-cmp").show({ providers = { "ripgrep" } })
--     end,
--   },
-- }

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "mikavilpas/blink-ripgrep.nvim",
      "Kaiser-Yang/blink-cmp-avante",
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
        end,
      },
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        ["<Up>"] = {},
        ["<Down>"] = {},
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {

        documentation = { auto_show = true },
      },
      snippets = { preset = "luasnip" },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = {
          "lazydev",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "ripgrep",
          -- "omni",
          -- "avante",
        },
        providers = {
          ripgrep = rip_grep_provider,
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          path = {
            score_offset = 10,
          },
          -- lsp = {
          --   score_offset = 11,
          -- },
        },
        per_filetype = {
          -- optionally inherit from the `default` sources
          lua = { inherit_defaults = true, "lazydev" },
        },
      },

      signature = {
        enabled = true,
        trigger = {
          show_on_insert = true,
        },
        window = {
          -- border = "shadow",
        },
      },
      -- documentation = {
      --
      --   -- Controls whether the documentation window will automatically show when selecting a completion item
      --   auto_show = true,
      --   auto_show_delay_ms = 50,
      --   window = {
      --     min_width = 10,
      --     max_width = 220,
      --     max_height = 120,
      --   },
      -- },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        use_proximity = false,
        use_frecency = false,

        sorts = {
          -- (optionally) always prioritize exact matches
          -- "exact",

          -- pass a function for custom behavior
          -- function(item_a, item_b)
          --   return item_a.score > item_b.score
          -- end,

          "score",
          "sort_text",
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
