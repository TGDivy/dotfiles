-- Personal profile overrides
-- Standard tooling — nothing special needed

-- 2-space indent for Lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "json", "yaml", "markdown" },
  callback = function()
    vim.opt_local.tabstop    = 2
    vim.opt_local.shiftwidth = 2
  end,
})
