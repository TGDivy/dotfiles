# dotfiles

Cross-platform dotfiles for macOS (personal + work) and RHEL8 (remote/SSH).  
Stack: **Ghostty · Fish · tmux · Neovim · Starship · Catppuccin Mocha**

---

## Quick Start

```bash
git clone https://github.com/TGDivy/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

make personal      # Home MacBook
make work          # Work MacBook (Bloomberg)
make work-remote   # Remote RHEL8 (SSH target — no Ghostty)
```

> Detects OS automatically: macOS → brew, Ubuntu → apt, RHEL → dnf.

---

## Machines

| Machine       | Profile    | Command           |
|---------------|------------|-------------------|
| Home MacBook  | `personal` | `make personal`   |
| Work MacBook  | `work`     | `make work`       |
| RHEL8 remote  | `work`     | `make work-remote`|
| Home Linux PC | `personal` | `make personal`   |

Profile written to `~/.dotfiles_profile`, read by Fish + Neovim on startup.

---

## Switch Profile (no reinstall)

```fish
use-profile work      # fish function — switches and reloads instantly
use-profile personal
```

---

## Directory Layout

```
dotfiles/
├── install.sh           # bootstrap (detects OS, installs, symlinks)
├── Makefile             # make personal | work | work-remote
├── profiles/            # env vars per profile
├── fish/                # config.fish + per-profile overrides
├── tmux/tmux.conf       # catppuccin, sessionx, resurrect
├── nvim/                # lazy.nvim, LSP, harpoon, render-markdown
├── ghostty/config       # mac only — SSH target uses Mac's Ghostty
├── git/                 # .gitconfig + per-profile identity
├── starship/            # starship.toml (catppuccin mocha, all platforms)
└── tools/               # clang-format.personal / clang-format.work
```

---

## Neovim Key Bindings

`<leader>` = **Space**

### Files & Navigation
| Key          | Action                         |
|--------------|--------------------------------|
| `<leader>ff` | Find files (cwd)               |
| `<leader>fF` | Find files (home)              |
| `<leader>fg` | Live grep (cwd)                |
| `<leader>fr` | Recent files                   |
| `<leader>fb` | Buffers                        |
| `<leader>e`  | Oil file explorer (cwd)        |
| `<leader>E`  | Oil file explorer (home)       |

### Harpoon (multi-project file marks)
| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>a`   | Add file to harpoon           |
| `<leader>h`   | Harpoon menu                  |
| `<C-1>–<C-4>` | Jump to mark 1–4              |
| `<C-S-p>`     | Prev mark                     |
| `<C-S-n>`     | Next mark                     |
| `<leader>fh`  | Fuzzy search marks (Telescope)|

### Git / Code Review
| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>gd`  | Diffview (full repo diff)     |
| `<leader>gD`  | Close diffview                |
| `<leader>gh`  | File git history              |
| `<leader>gH`  | Repo git history              |
| `<leader>gl`  | LazyGit TUI                   |
| `<leader>hs`  | Stage hunk                    |
| `<leader>hr`  | Reset hunk                    |
| `<leader>hb`  | Blame line (full)             |
| `<leader>tb`  | Toggle inline blame           |
| `]h` / `[h`   | Next/prev hunk                |

### LSP
| Key           | Action                        |
|---------------|-------------------------------|
| `gd`          | Go to definition              |
| `gD`          | Go to declaration             |
| `gr`          | References                    |
| `gi`          | Go to implementation          |
| `K`           | Hover docs                    |
| `<C-s>`       | Signature help                |
| `<leader>la`  | Code action                   |
| `<leader>lr`  | Rename symbol                 |
| `<leader>lf`  | Format buffer                 |
| `<leader>li`  | LSP info                      |

### Diagnostics
| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>xx`  | All diagnostics (Trouble)     |
| `<leader>xb`  | Buffer diagnostics            |
| `<leader>xs`  | Symbols                       |
| `<leader>ft`  | Find TODOs                    |

---

## tmux

Prefix: **`Ctrl+Space`**

| Key                | Action                       |
|--------------------|------------------------------|
| `prefix + \|`      | Vertical split               |
| `prefix + -`       | Horizontal split             |
| `prefix + h/j/k/l` | Navigate panes               |
| `prefix + o`       | Sessionx session picker      |
| `prefix + r`       | Reload config                |
| `prefix + Enter`   | Enter copy mode (vi keys)    |

Sessions auto-save every 10 min and restore on next launch (tmux-continuum).

---

## Fonts

Icons need a Nerd Font:

```bash
# Mac
brew install --cask font-jetbrains-mono-nerd-font

# Linux
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
curl -Lo JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip && fc-cache -fv
```

---

## Work Profile (Bloomberg)

- `~/.clang-format` → `tools/clang-format.work` (BDE 79-col style)
- Uncomment `UV_INDEX_URL` in `fish/profiles/work.fish` with Bloomberg PyPI URL
- Fill in `git/profiles/work.gitconfig` with your Bloomberg email
- `bde-format` binary: if present, conform.nvim uses it automatically for C++
- Uncomment `CMAKE_COMMAND=bbcmake` in `fish/profiles/work.fish`

---

## First Run Checklist

- [ ] Fill in `git/profiles/personal.gitconfig` (name + email)
- [ ] Fill in `git/profiles/work.gitconfig` (Bloomberg email)
- [ ] Set Bloomberg PyPI URL in `fish/profiles/work.fish`
- [ ] Install JetBrainsMono Nerd Font (handled by `make personal` on macOS)
- [ ] In tmux: `Ctrl+Space + I` to install TPM plugins on first launch
- [ ] Open `nvim` — Lazy auto-installs plugins on first launch
- [ ] `:Mason` in nvim to verify LSP servers installed
