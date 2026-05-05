local map = vim.keymap.set
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── Basics ────────────────────────────────────────────────────────────────────
map("n", "<leader>w",  "<cmd>w<cr>",          { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",          { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<cr>",        { desc = "Force quit all" })
map("n", "<Esc>",      "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- ── Windows ───────────────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>sv", "<C-w>v",              { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s",              { desc = "Split horizontal" })
map("n", "<leader>sx", "<cmd>close<cr>",      { desc = "Close split" })
map("n", "<leader>se", "<C-w>=",              { desc = "Equalise splits" })

-- ── Buffers ───────────────────────────────────────────────────────────────────
map("n", "<S-h>",      "<cmd>bprevious<cr>",  { desc = "Prev buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",      { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>",    { desc = "Delete buffer" })

-- ── Movement ──────────────────────────────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz")   -- keep cursor centered
map("n", "<C-u>", "<C-u>zz")
map("n", "n",     "nzzzv")
map("n", "N",     "Nzzzv")

-- ── Move lines ────────────────────────────────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- ── Stay in indent mode ───────────────────────────────────────────────────────
map("v", "<", "<gv")
map("v", ">", ">gv")

-- ── Paste without losing register ─────────────────────────────────────────────
map("x", "<leader>p", '"_dP',                 { desc = "Paste keep register" })

-- ── Diagnostics ───────────────────────────────────────────────────────────────
map("n", "[d", vim.diagnostic.goto_prev,      { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next,      { desc = "Next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- ── Quick-open (plugin keymaps defined in plugin specs) ───────────────────────
-- Telescope: <leader>f*
-- Harpoon:   <leader>a (add), <leader>h (menu), <C-1..4> (jump)
-- Oil:       -  (open file browser)
-- Trouble:   <leader>x*
-- Diffview:  <leader>gd
-- Lazygit:   <leader>gl

-- ── Markdown preview toggle ───────────────────────────────────────────────────
map("n", "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown render" })
