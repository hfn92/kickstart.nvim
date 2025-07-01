local NAME_REGEX = "\\%([^/\\\\:\\*?<>'\"`\\|]\\)"
local PATH_REGEX =
  vim.regex(([[\%(\%(/PAT*[^/\\\\:\\*?<>\'"`\\| .~]\)\|\%(/\.\.\)\)*/\zePAT*$]]):gsub("PAT", NAME_REGEX))

return {
  -- Autocompletion
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      "L3MON4D3/LuaSnip",
      -- build = (function()
      --   -- Build Step is needed for regex support in snippets.
      --   -- This step is not supported in many windows environments.
      --   -- Remove the below condition to re-enable on windows.
      --   if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      --     return
      --   end
      --   return 'make install_jsregexp'
      -- end)(),
      -- dependencies = {
      --   -- `friendly-snippets` contains a variety of premade snippets.
      --   --    See the README about individual language/framework/plugin snippets:
      --   --    https://github.com/rafamadriz/friendly-snippets
      --   -- {
      --   --   'rafamadriz/friendly-snippets',
      --   --   config = function()
      --   --     require('luasnip.loaders.from_vscode').lazy_load()
      --   --   end,
      --   -- },
      -- },
    },
    {
      "saghen/blink.compat",
      -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
      version = "*",
      -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
      lazy = true,
      -- make sure to set opts so that lazy.nvim calls blink.compat's setup
      opts = {
        debug = true,
      },
    },
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
    "saadparwaiz1/cmp_luasnip",

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "leiserfg/blink_luasnip",
    "milanglacier/minuet-ai.nvim",
  },
  -- "saghen/blink.cmp",
  "hfn92/blink.cmp",
  branch = "workaround2",
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source

  -- use a release tag to download pre-built binaries
  -- version = "v0.*",
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = "cargo build --release",
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
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
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      transform_items = function(ctx, items)
        local keyword = ctx.get_keyword()
        for _, item in ipairs(items) do
          if item.source_id == "luasnip" and keyword == item.label then
            item.score_offset = 500

            -- vim.notify(vim.inspect(item))
          end
        end
        -- vim.notify(vim.inspect(items))
        -- vim.notify(vim.inspect(keyword))
        return items
      end,

      default = { "luasnip", "lsp", "buffer", "lazydev", "path" },
      providers = {
        -- dont show LuaLS require statements when lazydev has items
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        -- luasnip = {
        --   name = "path",
        --   module = "blink.compat.source",
        --
        --   -- score_offset = 3,
        --
        --   -- transform_items = function(ctx, items)
        --   --   local keyword = ctx.get_keyword()
        --   --   for _, item in ipairs(items) do
        --   --     if keyword == item.label then
        --   --       item.score_offset = 50
        --   --     end
        --   --   end
        --   --   vim.notify(vim.inspect(keyword))
        --   --   -- vim.notify(vim.inspect(items))
        --   --   return items
        --   -- end,
        --
        --   -- opts = {
        --   --   use_show_condition = false,
        --   --   show_autosnippets = true,
        --   -- },
        -- },
        -- luasnip = {
        --   name = "luasnip",
        --   module = "blink_luasnip",
        --
        --   score_offset = -3,
        --
        --   ---@module 'blink_luasnip'
        --   ---@type blink_luasnip.Options
        --   opts = {
        --     use_show_condition = false, -- disables filtering completion candidates
        --     show_autosnippets = true,
        --     show_ghost_text = false, -- whether to show a preview of the selected snippet (experimental)
        --   },
        -- },
      },
      cmdline = {},
    },

    snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },

    completion = {

      -- menu = {
      documentation = {

        -- Controls whether the documentation window will automatically show when selecting a completion item
        auto_show = true,
        auto_show_delay_ms = 50,
        window = {
          min_width = 10,
          max_width = 220,
          max_height = 120,
        },
      },
      -- },
      keyword = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before *and* after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        range = "prefix",
        -- Regex used to get the text when fuzzy matching
        -- regex = "[\\[-_,/]\\|\\k",
        -- regex = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        -- regex = "\\%([^[:alnum:][:blank:]]\\|\\w\\+\\)",
        -- regex = "\\%([^[:alnum:][:blank:]]\\|\\w\\+\\)",
        -- regex = "[\\[-_]\\|\\k",
        -- After matching with regex, any characters matching this regex at the prefix will be excluded
        -- exclude_from_prefix_regex = "",
        custom_matcher = function(line)
          -- vim.notify(vim.inspect(line))
          local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
          local ls = require "luasnip"
          local sn = ls.get_snippets "cpp"

          local snips = {}

          for _, v in ipairs(sn) do
            if not snips[#v.trigger] then
              snips[#v.trigger] = {}
            end
            snips[#v.trigger][v.trigger] = true
          end

          local keys = vim.tbl_keys(snips)
          table.sort(keys, function(a, b)
            return a > b
          end)

          for _, len in ipairs(keys) do
            local part = line:sub(-len)
            if snips[len][part] then
              return #line - len
            end
          end

          -- for _, v in ipairs(sn) do
          --   local trigger = v.trigger
          --   if line:sub(-#trigger) == trigger then
          --     -- vim.notify("mathc:" .. trigger)
          --     return #line - #trigger
          --   end
          -- end

          -- local path_res = PATH_REGEX:match_str(line)
          -- if path_res then
          --   return path_res + 1
          -- end

          return nil
        end,
      },
      list = {
        selection = "auto_insert",
      },
      accept = {
        -- Create an undo point when accepting a completion item
        create_undo_point = true,
        -- Experimental auto-brackets support
        auto_brackets = {
          -- Whether to auto-insert brackets for functions
          enabled = true,
          -- Default brackets to use for unknown languages
          default_brackets = { "(", ")" },
          -- Overrides the default blocked filetypes
          override_brackets_for_filetypes = {},
          -- Synchronously use the kind of the item to determine if brackets should be added
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
          },
          -- Asynchronously use semantic token to determine if brackets should be added
          semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = {},
            -- How long to wait for semantic tokens to return before assuming no brackets should be added
            timeout_ms = 400,
          },
        },
      },
    },
    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        -- border = "shadow",
      },
    },
    fuzzy = {
      prebuilt_binaries = {
        ignore_version_mismatch = true,
      },
    },
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
