#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
PROFILE="${DOTFILES_PROFILE:-personal-mac}"
REMOTE="${DOTFILES_REMOTE:-0}"
LINK_ONLY=0

for arg in "$@"; do
  [[ "$arg" == "--link-only" ]] && LINK_ONLY=1
done

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[dotfiles]${NC} $*"; }
warn()    { echo -e "${YELLOW}[dotfiles]${NC} $*"; }
err()     { echo -e "${RED}[dotfiles]${NC} $*"; exit 1; }

# On Spaces (and other root environments) sudo doesn't exist — drop it
SUDO="sudo"
if [[ "$(id -u)" -eq 0 ]]; then SUDO=""; fi

OS="unknown"
if [[ "$(uname)" == "Darwin" ]]; then
  OS="macos"
elif [[ -f /etc/os-release ]]; then
  source /etc/os-release
  case "$ID" in
    ubuntu|debian|pop)  OS="debian" ;;
    rhel|centos|fedora) OS="rhel"   ;;
  esac
fi
info "OS: $OS | Profile: $PROFILE | Remote: $REMOTE"

install_tpm() {
  mkdir -p "$HOME/.tmux/plugins"

  if [[ -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
    info "TPM already installed"
    return
  fi

  if [[ -e "$HOME/.tmux/plugins/tpm" ]]; then
    warn "Removing invalid TPM path"
    rm -rf "$HOME/.tmux/plugins/tpm"
  fi

  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

install_packages() {
  if [[ $LINK_ONLY -eq 1 ]]; then return; fi

  case "$OS" in
    macos)
      if ! command -v brew &>/dev/null; then
        warn "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew bundle --file="$DOTFILES/Brewfile"
      install_tpm
      ;;
    debian)
      $SUDO apt-get update -qq
      $SUDO apt-get install -y \
        fish tmux git curl wget unzip ripgrep fd-find fzf \
        neovim clang clang-format clangd cmake \
        python3 python3-pip build-essential
      pip3 install --user cmake-format
      curl -LsSf https://astral.sh/uv/install.sh | sh
      curl -sS https://starship.rs/install.sh | sh -s -- --yes
      install_tpm
      ;;
    rhel)
      $SUDO dnf install -y epel-release 2>/dev/null || true
      $SUDO dnf install -y \
        fish tmux git curl wget unzip ripgrep fzf \
        clang clang-tools-extra cmake \
        python3 python3-pip gcc gcc-c++ make
      if ! nvim --version 2>/dev/null | grep -qE "NVIM v0\.[89]|NVIM v[1-9]"; then
        warn "RHEL nvim too old — installing AppImage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        $SUDO tar -C /usr/local -xzf nvim-linux-x86_64.tar.gz --strip-components=1
        rm nvim-linux-x86_64.tar.gz
      fi
      pip3 install --user cmake-format
      curl -LsSf https://astral.sh/uv/install.sh | sh
      curl -sS https://starship.rs/install.sh | sh -s -- --yes
      install_tpm
      ;;
    *)
      warn "Unknown OS — skipping package install."
      ;;
  esac
}

safe_link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backing up $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  info "Linked $dst"
}

link_configs() {
  safe_link "$DOTFILES/fish"                   "$HOME/.config/fish"
  safe_link "$DOTFILES/nvim"                   "$HOME/.config/nvim"
  safe_link "$DOTFILES/tmux/tmux.conf"         "$HOME/.tmux.conf"
  safe_link "$DOTFILES/git/gitconfig"          "$HOME/.gitconfig"
  safe_link "$DOTFILES/git/gitignore_global"   "$HOME/.gitignore_global"
  safe_link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

  if [[ "$OS" == "macos" && "$REMOTE" != "1" ]]; then
    safe_link "$DOTFILES/ghostty" "$HOME/.config/ghostty"
  fi

  safe_link "$DOTFILES/tools/clang-format.$PROFILE" "$HOME/.clang-format"
}

write_profile_marker() {
  echo "export DOTFILES_PROFILE=$PROFILE" > "$HOME/.dotfiles_profile"
  info "Profile: $PROFILE"
}

set_fish_shell() {
  if [[ $LINK_ONLY -eq 1 ]]; then return; fi
  local fish_path
  fish_path=$(command -v fish 2>/dev/null) || { warn "fish not found"; return; }
  if ! grep -qF "$fish_path" /etc/shells 2>/dev/null; then
    echo "$fish_path" | $SUDO tee -a /etc/shells
  fi
  if [[ "$SHELL" != "$fish_path" ]]; then
    chsh -s "$fish_path" && info "Default shell → fish"
  fi
}

write_brewfile() {
  [[ "$OS" != "macos" ]] && return

  # Base packages — all profiles
  cat > "$DOTFILES/Brewfile" << 'BREW'
brew "fish"
brew "starship"
brew "tmux"
brew "neovim"
brew "fzf"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "zoxide"
brew "git"
brew "git-delta"
brew "lazygit"
brew "uv"
brew "ruff"
brew "jq"
brew "htop"
brew "wget"
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"
BREW

  # Personal only: cmake + llvm
  # Bloomberg machines use bbcmake and Bloomberg-provisioned clang — skip to
  # avoid conflicts with any cmake-app cask already installed by IT.
  if [[ "$PROFILE" == "personal-mac" ]]; then
    cat >> "$DOTFILES/Brewfile" << 'BREW'
brew "llvm"
brew "cmake"
BREW
  fi

  info "Brewfile written"
}

# ── Git profile active symlink ────────────────────────────────────────────────
setup_git_profile() {
  local src="$DOTFILES/git/profiles/$PROFILE.gitconfig"
  local dst="$DOTFILES/git/profiles/active.gitconfig"
  if [[ -f "$src" ]]; then
    ln -sfn "$src" "$dst"
    info "Git profile → $PROFILE"
  else
    warn "Git profile not found: $src"
  fi
}

bootstrap_nvim() {
  if [[ $LINK_ONLY -eq 1 ]]; then return; fi
  if ! command -v nvim &>/dev/null; then warn "nvim not found — skipping plugin bootstrap"; return; fi

  info "Bootstrapping Neovim plugins headlessly (this takes ~2 min)..."
  # Run Lazy sync in headless mode so plugins are ready on first launch.
  # On bloomberg-* profiles this inherits the proxy env from the make invocation.
  # Use lua directly — "+Lazy! sync" +qa races against async plugin downloads.
  if nvim --headless -c "lua require('lazy').sync({wait=true, show=false})" -c "qall" 2>&1 | grep -v "^$"; then
    info "Neovim plugins installed"
  else
    warn "Lazy sync had errors — open nvim and run :Lazy sync manually"
  fi
}

write_brewfile
install_packages
link_configs
write_profile_marker
set_fish_shell
setup_git_profile
bootstrap_nvim

info "Done! Run: exec fish"
info "tmux: press prefix+I on first launch to install plugins"

if [[ "$PROFILE" == bloomberg-* ]]; then
  info ""
  info "Bloomberg Mac note: if any tool needs external internet (brew, nvim, curl),"
  info "prefix the command with the proxy:"
  info "  http_proxy=http://proxy.bloomberg.com:81 https_proxy=http://proxy.bloomberg.com:81 <cmd>"
  info "Or use the 'ext_proxy' fish abbr once fish is your shell."
fi

