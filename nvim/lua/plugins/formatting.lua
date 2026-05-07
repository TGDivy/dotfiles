return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd   = "ConformInfo",
    opts  = {
      formatters_by_ft = {
        -- C/C++: clang-format uses ~/.clang-format (profile-symlinked)
        c   = { "clang_format" },
        cpp = { "clang_format" },

        -- Python: ruff handles both sort + format
        python = { "ruff_fix", "ruff_format" },

        -- Lua
        lua = { "stylua" },

        -- CMake: uses $CMAKE_FORMATTER env (cmake-format or bbcmake)
        cmake = { "cmake_format_wrapper" },

        -- TypeScript / JavaScript
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },

        -- TOML
        toml = { "taplo" },

        -- Web / config
        json     = { "prettier" },
        yaml     = { "prettier" },
        markdown = { "prettier" },
        xml      = { "prettier" },
      },

      -- Format on save
      format_on_save = function(bufnr)
        -- Disable for files in certain paths (e.g. vendored code)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path:match("/vendor/") or path:match("/third_party/") then
          return
        end
        return { timeout_ms = 1000, lsp_fallback = true }
      end,

      -- Custom formatters
      formatters = {
        cmake_format_wrapper = {
          command  = function()
            return os.getenv("CMAKE_FORMATTER") or "cmake-format"
          end,
          args     = { "-" },
          stdin    = true,
        },
        clang_format = {
          -- will auto-find ~/.clang-format (which is symlinked to profile style)
          prepend_args = { "--style=file" },
        },
      },
    },
    keys = {
      { "<leader>lf", function() require("conform").format({ async = true }) end,
        desc = "Format buffer" },
    },
  },
}
