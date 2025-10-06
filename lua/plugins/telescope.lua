local function getVisualSelection()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg "v"
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

local max_tail_length = 0

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

local function padded_path_display(opts, path)
  local tail = require("telescope.utils").path_tail(path)
  if #tail > max_tail_length then
    max_tail_length = #tail
  end

  local win_id = vim.api.nvim_get_current_win()
  local win_width = vim.api.nvim_win_get_width(win_id)

  local padding = max_tail_length - #tail
  local padded_tail = tail .. string.rep(" ", padding)
  padded_tail = padded_tail .. "\t\t"
  -- limit total width to avoid overflow
  local path_text = string.format("%s (%s)", padded_tail, path)
  if #path_text > win_width - 2 then
    local trim_length = #path_text - (win_width - 2)
    path_text = padded_tail .. " (" .. string.sub(path, 1 + trim_length) .. "…)"
  end

  return path_text, { { { 1 + padding, #padded_tail + padding }, "Constant" } }
end

return {
  -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },

  config = function(_, opts)
    local builtin = require "telescope.builtin"
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    require("telescope").setup {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
          i = {
            ["<A-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<A-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<A-a>"] = actions.add_to_qflist + actions.open_qflist,
            ["<A-S-a>"] = actions.add_selected_to_qflist + actions.open_qflist,
            ["<C-h>"] = actions.select_horizontal,
          },
          n = {
            ["q"] = require("telescope.actions").close,
            ["<A-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<A-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<A-a>"] = actions.add_to_qflist + actions.open_qflist,
            ["<A-S-a>"] = actions.add_selected_to_qflist + actions.open_qflist,
            ["<C-h>"] = actions.select_horizontal,
          },
        },
      },

      pickers = {
        find_files = {
          path_display = function(opts, path)
            return padded_path_display(opts, path)
          end,
        },

        git_commits = {
          mappings = {
            i = {
              ["<CR>"] = function()
                local entry = action_state.get_selected_entry()
                actions.close(vim.api.nvim_get_current_buf())
                vim.cmd(("DiffviewOpen %s^!"):format(entry.value))
              end,
            },
            n = {
              ["<CR>"] = function()
                local entry = action_state.get_selected_entry()
                actions.close(vim.api.nvim_get_current_buf())
                vim.cmd(("DiffviewOpen %s^!"):format(entry.value))
              end,
            },
          },
        },
      },

      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },

      -- extensions = {
      --   ["ui-select"] = {
      --     require("telescope.themes").get_dropdown(),
      --   },
      -- },
      --
      -- extensions_list = { 'themes', 'terms' },
    }

    local grep = require "telescope.multigrep"

    SetKeyBinds {
      n = {

        -- find
        ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
        ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
        ["<leader>fw"] = { grep, "Live grep" },
        ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
        ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
        ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
        ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
        -- ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find Symbols" },
        ["<leader>fs"] = {
          function()
            -- require("telescope.builtin").lsp_document_symbols { show_line = true }
            require("telescope.builtin").lsp_document_symbols { symbol_width = 45 }
          end,
          "Find Symbols",
        },
        ["<leader>fe"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find symbols everywhere" },
        ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "Search git files" },
        ["<leader>fc"] = { "<cmd> Telescope git_status <CR>", "Search git diff" },
        ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", "Diagnostics" },
        ["<leader>fu"] = { "<cmd> Telescope grep_string <CR>", "Grep string under cursor" },
        ["<leader>fr"] = { "<cmd> lua require('telescope.builtin').lsp_references() <CR>", "Find references" },
        ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "Find marks" },
        ["<leader>fq"] = { "<cmd> Telescope quickfixhistory <CR>", "quickfixhistory" },

        -- git
        ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },

        ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
        ["<leader>f/r"] = { "<cmd> Telescope resume <CR>", "telescope resume" },

        ["<leader>f/c"] = {
          function()
            builtin.find_files { cwd = vim.fn.stdpath "config" }
          end,
          "search nvim config",
        },
        ["<leader>f/l"] = {
          function()
            builtin.find_files { cwd = vim.fn.stdpath "data" .. "/lazy" }
          end,
          "search lazy config",
        },
        ["<leader>f/af"] = {
          function()
            builtin.find_files { cwd = vim.fn.expand "%:p:h" }
          end,
          "find files around current file",
        },
        ["<leader>f/ag"] = {
          function()
            grep {
              cwd = vim.fn.expand "%:p:h",
            }
          end,
          "grep files around current file",
        },

        ["<leader>f/o"] = {
          function()
            builtin.live_grep {
              grep_open_files = true,
              prompt_title = "Live Grep in Open Files",
            }
          end,
          "grep open files",
        },
      },
      v = {
        ["<leader>fu"] = {
          function()
            require("telescope.builtin").grep_string {
              search = getVisualSelection(),
              only_sort_text = true,
            }
          end,
          "Find Text",
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    -- pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "themes")
    pcall(require("telescope").load_extension, "terms")
  end,
}
