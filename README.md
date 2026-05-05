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
| `<leader>ha`  | Add file to harpoon           |
| `<leader>hh`  | Harpoon menu                  |
| `<leader>1-5` | Jump to mark 1–5              |
| `<leader>hn`  | Next mark                     |
| `<leader>hp`  | Prev mark                     |
| `<leader>hf`  | Fuzzy search marks            |

### Git / Code Review
| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>gd`  | Diffview (full repo diff)     |
| `<leader>gh`  | File git history              |
| `<leader>gH`  | Repo git history              |
| `<leader>gc`  | Close diffview                |
| `<leader>gs`  | Git status (Telescope)        |
| `<leader>gb`  | Blame current line            |
| `<leader>gB`  | Toggle inline blame           |
| `<leader>gg`  | LazyGit TUI                   |
| `]c` / `[c`   | Next/prev hunk                |

### LSP
| Key           | Action                        |
|---------------|-------------------------------|
| `gd`          | Go to definition              |
| `gr`          | References                    |
| `K`           | Hover docs                    |
| `<leader>la`  | Code action                   |
| `<leader>lr`  | Rename symbol                 |
| `<leader>lf`  | Format buffer                 |

### Diagnostics
| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>xx`  | All diagnostics (Trouble)     |
| `<leader>xb`  | Buffer diagnostics            |
| `<leader>xs`  | Symbols                       |
| `<leader>ft`  | Find TODOs                    |

---

## tmux

Prefix: **`Ctrl+a`**

| Key               | Action                       |
|-------------------|------------------------------|
| `prefix + \|`     | Vertical split               |
| `prefix + -`      | Horizontal split             |
| `prefix + h/j/k/l`| Navigate panes              |
| `prefix + o`      | Sessionx session picker      |
| `M-s`             | Choose session (no prefix)   |
| `M-1..5`          | Jump to window (no prefix)   |
| `prefix + r`      | Reload config                |

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
- [ ] Install JetBrainsMono Nerd Font
- [ ] In tmux: `prefix + I` to install TPM plugins
- [ ] Open `nvim` — Lazy auto-installs plugins on first launch
- [ ] `:Mason` in nvim to verify LSP servers installed
