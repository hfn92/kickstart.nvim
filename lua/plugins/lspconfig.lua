return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  lazy = false,

  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/null-ls.nvim",
    "ray-x/lsp_signature.nvim",
  },
  config = function()
    local highlights_active = false
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = function()
              if highlights_active then
                vim.lsp.buf.document_highlight()
              end
            end,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
            end,
          })
        end

        -- local highlights_off = function()
        --   vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight" }
        -- end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        --   map("<leader>th", function()
        --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        --   end, "[T]oggle Inlay [H]ints")
        -- end
      end,
    })

    SetKeyBinds {
      n = {
        ["H"] = {
          function()
            vim.lsp.buf.document_highlight()
          end,
          "highlight symbol under cursor",
        },
        ["<leader>th"] = {
          function()
            highlights_active = not highlights_active
            if not highlights_active then
              vim.lsp.buf.clear_references()
            end
          end,
          "Toogle lsp highlights",
        },
      },
    }

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- tsserver = {},
      --

      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "lua_ls",
      "clangd",
      "cmake",
      "pylsp",
    })
    require("mason-tool-installer").setup { ensure_installed = ensure_installed }

    require("mason-lspconfig").setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    }

    local ccapabilities = vim.lsp.protocol.make_client_capabilities()
    ccapabilities.offsetEncoding = { "utf-16" }

    require("lspconfig").clangd.setup {
      on_attach = function(client, bufnr)
        require("lsp_signature").on_attach(client, bufnr) -- Note: add in lsp client on-attach
        require("lsp-format").on_attach(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
      end,
      on_new_config = function(new_config, new_cwd)
        local status, cmake = pcall(require, "cmake-tools")
        if status then
          cmake.clangd_on_new_config(new_config)
        end
      end,
      capabilities = ccapabilities,
      filetypes = { "c", "cpp" },
      cmd = {
        "clangd",
        "--clang-tidy",
        "--header-insertion=never",
      },
    }

    local function is_in_config_folder()
      local cwd = vim.fn.getcwd()
      local config_path = vim.fn.stdpath "config"
      return cwd == config_path
    end

    require("lspconfig").lua_ls.setup {
      on_attach = function(client, bufnr)
        -- require("lsp_signature").on_attach(client, bufnr) -- Note: add in lsp client on-attach
        -- require("lsp-format").on_attach(client, bufnr)
        -- client.server_capabilities.semanticTokensProvider = nil
        client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
      end,
      root_dir = function()
        local util = require "lspconfig.util"
        return util.find_git_ancestor(vim.fn.getcwd())
      end,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = (function()
              return is_in_config_folder() and { "vim" } or nil
            end)(),
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = (function()
              return is_in_config_folder() and vim.api.nvim_get_runtime_file("", true) or nil
            end)(),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
    require("lspconfig").neocmake.setup {}
    require("lspconfig").asm_lsp.setup {}
    require("lspconfig").pylsp.setup {}
    require("lspconfig").marksman.setup {}

    -- local mason_registry = require "mason-registry"
    -- local vale = mason_registry.get_package "vale"
    -- -- vim.notify(vim.inspect(vale))
    -- require("lspconfig").vale_ls.setup {}
    -- require("lspconfig").ltex.setup {}
  end,
}
