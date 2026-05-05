-- ── profiles/init.lua ────────────────────────────────────────────────────────
-- Reads DOTFILES_PROFILE env var (set by fish/install.sh) and loads
-- the corresponding profile overrides.

local profile = os.getenv("DOTFILES_PROFILE") or "personal"

local ok, err = pcall(require, "profiles." .. profile)
if not ok then
  -- Don't crash if profile file doesn't exist yet
  vim.notify("dotfiles: no profile found for '" .. profile .. "'\n" .. tostring(err),
    vim.log.levels.WARN, { title = "dotfiles" })
end
