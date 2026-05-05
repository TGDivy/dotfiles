-- ── plugins/lsp.lua ──────────────────────────────────────────────────────────
return {

  -- ── mason — LSP/tool installer ─────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd",              -- C++
        "basedpyright",        -- Python type checking
        "ruff",                -- Python lint + format (replaces pylsp)
        "lua_ls",              -- Lua (for nvim config)
        "cmake",               -- CMake
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
      { "folke/neodev.nvim", opts = {} },   -- neovim API completions for lua_ls
    },
    config = function()
      local lspconfig  = require("lspconfig")
      local cmp_lsp    = require("cmp_nvim_lsp")
      local profile    = os.getenv("DOTFILES_PROFILE") or "personal"

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
      )

      -- ── on_attach: keymaps active only when LSP is attached ────────────────
      local on_attach = function(client, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        map("gd",         vim.lsp.buf.definition,       "Go to definition")
        map("gD",         vim.lsp.buf.declaration,      "Go to declaration")
        map("gr",         "<cmd>Telescope lsp_references<cr>",       "References")
        map("gi",         "<cmd>Telescope lsp_implementations<cr>",  "Implementations")
        map("gt",         "<cmd>Telescope lsp_type_definitions<cr>", "Type definition")
        map("K",          vim.lsp.buf.hover,             "Hover docs")
        map("<leader>la", vim.lsp.buf.code_action,       "Code action")
        map("<leader>lr", vim.lsp.buf.rename,            "Rename")
        map("<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",  "Document symbols")
        map("<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols")
        map("[d",         vim.diagnostic.goto_prev,      "Prev diagnostic")
        map("]d",         vim.diagnostic.goto_next,      "Next diagnostic")
        map("<leader>ld", vim.diagnostic.open_float,     "Diagnostic float")
      end

      -- ── diagnostic UI ──────────────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source  = "if_many",
        },
        float = {
          border = "rounded",
          source = true,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        underline    = true,
        update_in_insert = false,
        severity_sort    = true,
      })

      -- ── C++ / clangd ───────────────────────────────────────────────────────
      local clangd_cmd = { "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=google",
      }

      -- Work profile: use BDE/Bloomberg compile_commands if present
      if profile == "work" then
        table.insert(clangd_cmd, "--compile-commands-dir=build")
      end

      lspconfig.clangd.setup({
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        }),
        on_attach   = on_attach,
        cmd         = clangd_cmd,
        filetypes   = { "c", "cpp", "objc", "objcpp" },
      })

      -- ── Python — basedpyright ───────────────────────────────────────────────
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode     = "standard",
              autoSearchPaths      = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- ── Python — ruff (replaces ruff-lsp, built-in since ruff 0.4) ─────────
      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach    = function(client, bufnr)
          on_attach(client, bufnr)
          -- Disable hover in favour of basedpyright's richer hover
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- ── CMake ──────────────────────────────────────────────────────────────
      lspconfig.cmake.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
      })

      -- ── Lua ────────────────────────────────────────────────────────────────
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },

  -- ── conform — formatting ───────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    opts = function()
      local profile = os.getenv("DOTFILES_PROFILE") or "personal"

      local cpp_formatter = "clang_format"   -- uses ~/.clang-format (symlinked by install.sh)

      -- Work profile: if bde-format binary exists, prefer it
      if profile == "work" and vim.fn.executable("bde-format") == 1 then
        cpp_formatter = {
          command = "bde-format",
          args    = { "$FILENAME" },
          stdin   = false,
        }
      end

      return {
        formatters_by_ft = {
          c          = { cpp_formatter },
          cpp        = { cpp_formatter },
          python     = { "ruff_format", "ruff_fix" },
          lua        = { "stylua" },
          cmake      = { "cmake_format" },
          markdown   = { "prettier" },
          json       = { "prettier" },
          yaml       = { "prettier" },
          sh         = { "shfmt" },
          fish       = { "fish_indent" },
        },
        format_on_save = {
          timeout_ms    = 1000,
          lsp_fallback  = true,
        },
      }
    end,
  },
}
