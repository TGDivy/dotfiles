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

-- Clipboard — OSC 52 over SSH/tmux
-- The built-in vim.ui.clipboard.osc52 uses io.write() which doesn't reliably
-- reach the terminal when running inside tmux. Using chansend(v:stderr) instead
-- writes directly to nvim's terminal fd — works in bare SSH and tmux.
local function osc52_copy(reg)
  return function(lines, _)
    local data = table.concat(lines, "\n")
    local encoded = vim.base64.encode(data)
    local seq = string.format("\027]52;%s;%s\027\\", reg == "*" and "p" or "c", encoded)
    -- DCS passthrough for tmux
    if vim.env.TMUX then
      seq = string.format("\027Ptmux;\027%s\027\\", seq)
    end
    vim.fn.chansend(vim.v.stderr, seq)
  end
end

vim.g.clipboard = {
  name  = "OSC 52",
  copy  = { ["+"] = osc52_copy("+"), ["*"] = osc52_copy("*") },
  paste = {
    ["+"] = function() return { vim.fn.getreg("+", 1, true), vim.fn.getregtype("+") } end,
    ["*"] = function() return { vim.fn.getreg("*", 1, true), vim.fn.getregtype("*") } end,
  },
}
o.clipboard = "unnamedplus"

-- Fold (using treesitter — v1.0 API)
o.foldmethod = "expr"
o.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
o.foldenable = false   -- open all folds by default
o.foldlevel  = 99

-- Spell
o.spelllang = "en_gb"
