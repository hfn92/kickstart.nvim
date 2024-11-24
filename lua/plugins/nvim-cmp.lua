return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
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
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    "saadparwaiz1/cmp_luasnip",

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    -- See `:help cmp`
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local cmp_ui = {
      icons = true,
      lspkind_text = true,
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
      selected_item_bg = "colored", -- colored / simple
    }

    local function border(hl_name)
      return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
      }
    end

    local cmp_style = "kind"

    local field_arrangement = {
      atom = { "kind", "abbr", "menu" },
      atom_colored = { "kind", "abbr", "menu" },
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        -- completion = {
        --   -- side_padding = 0,
        --   side_padding = (cmp_style ~= 'atom' and cmp_style ~= 'atom_colored') and 1 or 0,
        --   winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
        --   -- scrollbar = false,
        -- },
        -- completion = cmp.config.window.bordered(),
        -- documentation = {
        --   -- border = border 'CmpDocBorder',
        --   winhighlight = 'Normal:CmpDoc',
        -- },
        completion = {
          completeopt = "menu,menuone,noinsert",
          -- winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
          -- winhighlight = 'Normal:GitSignsAdd,FloatBorder:GitSignsAdd,CursorLine:GitSignsAdd,Search:GitSignsAdd',
        },
      },
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        -- default fields order i.e completion word + item.kind + item.kind icons
        fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

        format = function(_, item)
          local icons = require "custom.icons.lspkind"
          local icon = (cmp_ui.icons and icons[item.kind]) or ""

          -- if cmp_style == 'atom' or cmp_style == 'atom_colored' then
          --   icon = ' ' .. icon .. ' '
          --   item.menu = cmp_ui.lspkind_text and '   (' .. item.kind .. ')' or ''
          --   item.kind = icon
          -- else
          --   icon = cmp_ui.lspkind_text and (' ' .. icon .. ' ') or icon
          item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
          -- end

          return item
        end,
      },
      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      -- cmp.mapping.preset.insert
      mapping = {
        -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),

        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
      sources = {
        {
          name = "lazydev",
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      },
    }
  end,
}