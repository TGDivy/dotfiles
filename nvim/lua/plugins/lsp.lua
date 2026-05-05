return {
  -- ── Mason: LSP installer ───────────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts  = { ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } } },
  },

  -- ── Mason-lspconfig bridge ─────────────────────────────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd",          -- C/C++
        "basedpyright",    -- Python (strict mode pyright fork)
        "ruff",            -- Python linting/formatting as LSP
        "cmake",           -- CMakeLists.txt
        "lua_ls",          -- Lua (nvim config)
        "marksman",        -- Markdown
        "jsonls",          -- JSON
        "yamlls",          -- YAML
      },
      automatic_installation = true,
    },
  },

  -- ── nvim-lspconfig ─────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/lazydev.nvim", ft = "lua", opts = {} },  -- nvim lua API types
    },
    config = function()
      local lspconfig  = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ── On-attach keymaps (set per-buffer) ──────────────────────────────────
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        local b = require("telescope.builtin")

        map("gd",         b.lsp_definitions,       "Go to definition")
        map("gD",         vim.lsp.buf.declaration,  "Go to declaration")
        map("gr",         b.lsp_references,         "Go to references")
        map("gi",         b.lsp_implementations,    "Go to implementation")
        map("gt",         b.lsp_type_definitions,   "Go to type definition")
        map("K",          vim.lsp.buf.hover,         "Hover docs")
        map("<C-s>",      vim.lsp.buf.signature_help,"Signature help")
        map("<leader>lr", vim.lsp.buf.rename,        "Rename symbol")
        map("<leader>la", vim.lsp.buf.code_action,   "Code action")
        map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
        map("<leader>li", "<cmd>LspInfo<cr>",        "LSP info")
      end

      -- ── clangd ──────────────────────────────────────────────────────────────
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--offset-encoding=utf-16",
        },
        filetypes   = { "c", "cpp", "objc", "objcpp" },
        root_dir    = require("lspconfig.util").root_pattern(
          "compile_commands.json", "compile_flags.txt", "CMakeLists.txt", ".git"
        ),
      })

      -- ── basedpyright (Python) ────────────────────────────────────────────────
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode          = "standard",
              autoSearchPaths           = true,
              useLibraryCodeForTypes    = true,
              diagnosticMode            = "openFilesOnly",
            },
          },
        },
      })

      -- ── ruff (Python fast linter as LSP — disables pylsp overlap) ───────────
      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach    = function(client, bufnr)
          on_attach(client, bufnr)
          -- Disable hover in favour of basedpyright
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- ── cmake ───────────────────────────────────────────────────────────────
      lspconfig.cmake.setup({ capabilities = capabilities, on_attach = on_attach })

      -- ── marksman (markdown) ─────────────────────────────────────────────────
      lspconfig.marksman.setup({ capabilities = capabilities, on_attach = on_attach })

      -- ── lua_ls ──────────────────────────────────────────────────────────────
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          Lua = {
            diagnostics    = { globals = { "vim" } },
            workspace      = { checkThirdParty = false },
            telemetry      = { enable = false },
          },
        },
      })

      -- ── JSON / YAML ─────────────────────────────────────────────────────────
      lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.yamlls.setup({ capabilities = capabilities, on_attach = on_attach })

      -- ── Diagnostics UI ──────────────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text    = { prefix = "●", source = "if_many" },
        signs           = true,
        update_in_insert = false,
        float           = { border = "rounded", source = true },
        severity_sort   = true,
      })

      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
}
