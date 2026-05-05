local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 }) end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Wrap + spell in markdown/gitcommit
autocmd("FileType", {
  group = augroup("TextFiles", { clear = true }),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap    = true
    vim.opt_local.spell   = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 2  -- allow render-markdown to render
  end,
})

-- C++ specific indentation (2 spaces for BDE style)
autocmd("FileType", {
  group = augroup("CppSettings", { clear = true }),
  pattern = { "cpp", "c" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = augroup("AutoResize", { clear = true }),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- Close quickfix/help/etc with q
autocmd("FileType", {
  group = augroup("QuickClose", { clear = true }),
  pattern = { "qf", "help", "man", "lspinfo", "checkhealth" },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Remember last cursor position
autocmd("BufReadPost", {
  group = augroup("LastCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
