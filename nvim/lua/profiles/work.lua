-- ── profiles/work.lua ────────────────────────────────────────────────────────
-- Bloomberg work overrides

-- Extra clangd flags for BDE-style codebases
-- Injected into the clangd server started in lsp.lua via vim.g so lsp.lua
-- can read them at setup time — but lsp.lua reads DOTFILES_PROFILE directly,
-- so this file is mainly for runtime overrides and future extensions.

-- BDE typically puts compile_commands.json in build/ or .cache/
vim.g.dotfiles_work_compile_commands = "build"

-- Register any Bloomberg-internal file associations
vim.filetype.add({
  extension = {
    bbcmake = "cmake",     -- bbcmake files use cmake syntax
  },
})

vim.notify("dotfiles: work (Bloomberg) profile loaded", vim.log.levels.INFO,
  { title = "dotfiles", timeout = 1000 })
