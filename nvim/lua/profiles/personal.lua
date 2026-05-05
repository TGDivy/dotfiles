-- ── profiles/personal.lua ────────────────────────────────────────────────────
-- Home MacBook overrides — standard open-source toolchain

-- Nothing special to override for personal. Defaults in lsp.lua apply:
--   clang-format: uses ~/.clang-format → tools/clang-format.personal
--   uv: standard pypi.org
--   cmake: cmake

vim.notify("dotfiles: personal profile loaded", vim.log.levels.INFO,
  { title = "dotfiles", timeout = 1000 })
