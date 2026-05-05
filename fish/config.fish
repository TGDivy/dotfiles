# ── Bootstrap profile ─────────────────────────────────────────────────────────
if test -f ~/.dotfiles_profile
    source ~/.dotfiles_profile
end

set -gx DOTFILES_PROFILE (test -n "$DOTFILES_PROFILE"; and echo $DOTFILES_PROFILE; or echo personal)

# Source profile-specific config
set -l profile_file ~/.dotfiles/fish/profiles/$DOTFILES_PROFILE.fish
if test -f $profile_file
    source $profile_file
end

# ── PATH ──────────────────────────────────────────────────────────────────────
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /usr/local/bin

# uv managed python tools
fish_add_path ~/.local/share/uv/tools/bin 2>/dev/null; or true

# macOS: Homebrew
if test (uname) = Darwin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/opt/llvm/bin  # clangd, clang-format
end

# ── Core env ──────────────────────────────────────────────────────────────────
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER "less -RF"
set -gx BAT_THEME "Catppuccin Mocha"

# fzf defaults — catppuccin mocha colors
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
set -gx FZF_DEFAULT_OPTS "\
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --multi"

# zoxide (smarter cd)
if command -q zoxide
    zoxide init fish | source
end

# starship prompt
if command -q starship
    starship init fish | source
end

# ── Abbreviations ─────────────────────────────────────────────────────────────
abbr -a vim  nvim
abbr -a vi   nvim
abbr -a v    nvim

# ls → eza
if command -q eza
    abbr -a ls  'eza --icons --group-directories-first'
    abbr -a ll  'eza -la --icons --group-directories-first --git'
    abbr -a lt  'eza --tree --icons --level=2'
    abbr -a ltt 'eza --tree --icons --level=3'
else
    abbr -a ll 'ls -la'
end

# cat → bat
if command -q bat
    abbr -a cat bat
end

# git
abbr -a g    git
abbr -a ga   'git add'
abbr -a gc   'git commit'
abbr -a gco  'git checkout'
abbr -a gd   'git diff'
abbr -a gds  'git diff --staged'
abbr -a gl   'git log --oneline --graph --decorate'
abbr -a gp   'git push'
abbr -a gs   'git status'
abbr -a gst  'git stash'
abbr -a lg   lazygit

# tmux
abbr -a ta  'tmux attach -t'
abbr -a tls 'tmux list-sessions'
abbr -a tn  'tmux new -s'

# dotfiles
abbr -a dot 'cd ~/.dotfiles'
abbr -a dotup 'cd ~/.dotfiles && git pull && make $DOTFILES_PROFILE'
