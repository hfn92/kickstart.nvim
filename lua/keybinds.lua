-- [[ Quickfix ]]
SetKeyBinds {
  i = {
    ["<A-j>"] = { "<cmd>cnext<CR>zz", "Quickfix next" },
    ["<A-k>"] = { "<cmd>cprev<CR>zz", "Quickfix previous" },
    ["<A-S-k>"] = { ":colder<CR>", "Quickfix older match" },
    ["<A-S-j>"] = { ":cnewer<CR>", "Quickfix newer match" },
  },
  n = {
    ["<A-j>"] = { "<cmd>cnext<CR>zz", "Quickfix next" },
    ["<A-k>"] = { "<cmd>cprev<CR>zz", "Quickfix previous" },
    ["<A-S-k>"] = { ":colder<CR>", "Quickfix older match" },
    ["<A-S-j>"] = { ":cnewer<CR>", "Quickfix newer match" },
    ["<leader>k"] = { "<cmd>lnext<CR>zz", "Location next" },
    ["<leader>j"] = { "<cmd>lprev<CR>zz", "Location previous" },

    ["<leader>qc"] = { "<cmd>cclose<CR>", "Quickfix close" },
    ["<leader>qv"] = { "<cmd>cclose<CR><cmd>vert copen 100<CR>", "Quickfix open vertical" },
    ["<leader>qb"] = { "<cmd>cclose<CR><cmd>bot copen 12<CR>", "Quickfix open bottom" },
    ["<leader>qu"] = { "<cmd>cclose<CR><cmd>belowright copen 12<CR>", "Quickfix open bottom right" },
    ["<leader>qe"] = { "<cmd>cexpr []<CR><cmd>cclose<CR>", "Quickfix clear" },
    ["<leader>qs"] = {
      [[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
      "substitute",
    },
    ["<leader>qr"] = {
      [[:cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
      "quickfix replace",
    },
    ["<leader>qd"] = { ":cdo delete", "Quickfix delete all matches" },
    ["<leader>qq"] = { ":cdo norm! @", "Quickfix macro" },
  },
}

-- [[ Diagnostics ]]
SetKeyBinds {
  i = {
    ["<F4>"] = { "<cmd> ClangdSwitchSourceHeader <CR>", "Switch Source/Header" },
  },

  n = {
    ["<leader>nn"] = { "<cmd> Noice <CR>", "Noice" },
    ["ff"] = { "<cmd> ClangdSwitchSourceHeader <CR>", "Switch Source/Header" },
    ["<C-w>b"] = { "<cmd>%bd|e#<CR>", "Close other buffers" },
    ["K"] = { "<cmd> lua vim.lsp.buf.hover() <CR>", "Hover" },
    ["<F4>"] = { "<cmd> ClangdSwitchSourceHeader <CR>", "Switch Source/Header" },
    ["cc"] = {
      function()
        vim.lsp.buf.declaration { on_list = function() end }
        vim.lsp.buf.definition {
          on_list = function()
            vim.cmd "Telescope lsp_definitions"
          end,
        }
      end,
      "Follow Symbol",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "Goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next",
    },
    ["<leader>ra"] = {
      function()
        require "utils.renamer"()
      end,
      "LSP rename",
    },
    ["<leader>dd"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },
  },
}

-- [[ Helper ]]
SetKeyBinds {
  n = {
    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
    ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace under cursor" },
  },
  v = {
    ["<leader>q"] = { [[:norm! @]], "Execute macro" },
    ["<leader>s"] = { [[:s///<Left><Left>]], "Replace within selection" },
    ["<leader>r"] = { [[y:%s/<C-R>=escape(@",'/\:.')<esc>//g<Left><Left>]], "Replace selection" },

    ["<C-p>"] = { ":diffput<CR>", "Move diff of other view" },
  },
}

-- [[ Navigation ]]
SetKeyBinds {
  i = {
    ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
    ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
    ["<C-S-s>"] = { "<cmd> wa <CR>", "Save all files" },
    ["<S-Down>"] = { "<Down>", "Move down" },
    ["<S-Up>"] = { "<Up>", "Move Up" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },

  n = {
    ["<C-d>"] = { "<C-d>zz", "Scroll down" },
    ["<C-f>"] = { "<C-u>zz", "Scroll up" },
    ["<C-u>"] = { "<C-u>zz", "Scroll up" },
    ["n"] = { "nzzzv", "next (search)" },
    ["N"] = { "Nzzzv", "previous (search)" },
    ["J"] = { "mzJ`z", "Move next line back" },
    ["<C-r>"] = { "<cmd> CMakeRun <CR>", "CMake run" },

    ["<A-Left>"] = { "<C-o>", "Navigate Backwards" },
    ["<A-Right>"] = { "<C-i>", "Navigate Forwards" },
    ["<C-S-s>"] = { "<cmd> wa <CR>", "Save all files" },

    ["<leader>y"] = { '"+y', "Yank to clipboard" },
    ["<leader>d"] = { '"_d', "Delete to void" },
    ["<leader>nh"] = { [[<cmd>lua require("notify").history()<CR>]], "Notification history" },
    ["<leader>dfs"] = { "<CMD>windo diffthis <CR>", "Diff split" },
    ["<leader>dfo"] = { "<CMD>windo diffoff <CR>", "Diff off" },
    ["<leader>doc"] = { "<CMD>Neogen<CR>", "Document under cursor" },
    ["<A-t>"] = { "<CMD>tabnew<CR>", "new tab" },
    ["<A-n>"] = { "<CMD>tabnext<CR>", "next tab" },
    ["<A-c>"] = { "<CMD>tabclose<CR>", "close tab" },

    ["<S-Down>"] = { "<Down>", "Move down" },
    ["<S-Up>"] = { "<Up>", "Move Up" },
    ["<C-,>"] = { "<CMD>vertical resize -5<CR>", "Resize vsplit -5" },
    ["<C-.>"] = { "<CMD>vertical resize +5<CR>", "Resize vsplit +5" },
    ["<C-;>"] = { "<CMD>resize -5<CR>", "Resize split -5" },
    ["<C-'>"] = { "<CMD>resize +5<CR>", "Resize split +5" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
  },
  v = {
    ["J"] = { ":m '>+1<CR>gv=gv", "Move down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move Up" },
    -- ["<S-Down>"] = { ":m '>+1<CR>gv=gv", "Move down" },
    -- ["<S-Up>"] = { ":m '<-2<CR>gv=gv", "Move Up" },
    ["<S-Down>"] = { "<Down>", "Move down" },
    ["<S-Up>"] = { "<Up>", "Move Up" },

    ["<leader>y"] = { '"+y', "Yank to clipboard" },
    ["<leader>d"] = { '"_d', "Delete to void" },
    ["<leader>b"] = { ":DiffviewFileHistory<CR>", "Git history" },

    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
  },
  x = {
    ["<leader>p"] = { '"_dP', "Paste" },

    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
  },
}
