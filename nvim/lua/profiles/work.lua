-- Work profile overrides (Bloomberg / BDE)

-- BDE uses 4-space indent for C++, 2 for BSL
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "79"  -- BDE 79-char line limit
  end,
})

-- Override clangd to disable clang-tidy (BDE has its own linter)
-- and point to BDE compile_commands if available
vim.defer_fn(function()
  local lspconfig = require("lspconfig")
  -- Re-setup clangd with BDE-aware settings
  -- clang-format will pick up ~/.clang-format (symlinked to work style)
  vim.notify("[work profile] BDE C++ settings active", vim.log.levels.INFO)
end, 1000)

-- bbcmake formatter (set via fish profile, but also set here as fallback)
if vim.fn.executable("bbcmake") == 1 then
  vim.env.CMAKE_FORMATTER = "bbcmake"
end
