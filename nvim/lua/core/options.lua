local o = vim.opt

-- UI
o.number         = true
o.relativenumber = true
o.cursorline     = true
o.signcolumn     = "yes"
o.colorcolumn    = "100"
o.scrolloff      = 8
o.sidescrolloff  = 8
o.wrap           = false
o.termguicolors  = true
o.showmode       = false     -- lualine handles this
o.laststatus     = 3         -- global statusline

-- Indentation
o.expandtab  = true
o.tabstop    = 4
o.shiftwidth = 4
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase  = true
o.hlsearch   = false
o.incsearch  = true

-- Files
o.swapfile = false
o.backup   = false
o.undofile = true
o.undodir  = os.getenv("HOME") .. "/.local/share/nvim/undodir"

-- Splits
o.splitright = true
o.splitbelow = true

-- Performance
o.updatetime  = 100
o.timeoutlen  = 300

-- Completion
o.completeopt = { "menuone", "noselect" }
o.pumheight   = 10

-- Clipboard — OSC 52 works locally (Ghostty) and over SSH/tmux
-- Use pcall in case the module path differs across nvim versions
local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
if ok then
  vim.g.clipboard = {
    name  = "OSC 52",
    copy  = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
o.clipboard = "unnamedplus"

-- Fold (using treesitter — v1.0 API)
o.foldmethod = "expr"
o.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
o.foldenable = false   -- open all folds by default
o.foldlevel  = 99

-- Spell
o.spelllang = "en_gb"
