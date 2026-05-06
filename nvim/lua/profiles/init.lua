-- Load profile based on $DOTFILES_PROFILE env var
local profile = os.getenv("DOTFILES_PROFILE") or "personal-mac"

local ok, err = pcall(require, "profiles." .. profile)
if not ok then
  vim.notify("Profile '" .. profile .. "' not found: " .. tostring(err), vim.log.levels.WARN)
end
