# nvim config

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim). Focused on C/C++ and Python development with AI assistance built in.

## Requirements

- Neovim >= 0.10
- Git
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal
- `clangd` (C/C++ LSP)
- `pyright` (Python LSP)
- `norminette` (optional, for 42 norm checking)
- `flake8` (optional, for Python linting)
- [Claude Code CLI](https://github.com/anthropics/claude-code) (optional, for AI terminal)

## Installation

```bash
git clone https://github.com/<your-username>/nvim-config ~/.config/nvim
nvim  # lazy.nvim auto-installs plugins on first launch
```

## Structure

```
~/.config/nvim/
├── init.lua                  # Entry point, sets leader key
├── lua/
│   ├── config/
│   │   ├── options.lua       # Editor settings
│   │   ├── keymaps.lua       # All keybindings
│   │   └── autocmds.lua      # Auto commands
│   └── plugins/
│       ├── init.lua          # lazy.nvim bootstrap
│       ├── colorschemes.lua  # Themes
│       ├── lualine.lua       # Status line
│       ├── treesitter.lua    # Syntax highlighting
│       ├── cmp.lua           # Completion
│       ├── lsp.lua           # Language servers
│       ├── ui.lua            # UI plugins
│       ├── copilot.lua       # GitHub Copilot
│       ├── claude.lua        # Claude Code integration
│       ├── toggleterm.lua    # Floating terminal
│       └── telescope.lua     # Fuzzy finder
```

## Plugins

| Plugin | Description |
|--------|-------------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | Default colorscheme (dragon theme) |
| [nord.nvim](https://github.com/gbprod/nord.nvim) | Nord colorscheme (lazy) |
| [melange-nvim](https://github.com/savq/melange-nvim) | Melange colorscheme (lazy) |
| [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) | Cyberdream colorscheme (lazy) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting (C, C++, Lua, Python, Bash) |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration (clangd, pyright) |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [BufferTabs.nvim](https://github.com/tomiis4/BufferTabs.nvim) | Buffer tabs at the bottom |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [stcursorword](https://github.com/sontungexpt/stcursorword) | Underline word under cursor |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi) | Multiple cursors |
| [multiple-cursors.nvim](https://github.com/brenton-leighton/multiple-cursors.nvim) | Additional multi-cursor support |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |

## Keybindings

**Leader key: `Space`**

### Navigation

| Key | Mode | Action |
|-----|------|--------|
| `h j k l` | Normal | Left / Down / Up / Right |
| `w` / `b` | Normal | Next / prev word |
| `gg` / `G` | Normal | File top / bottom |
| `Ctrl+d` / `Ctrl+u` | Normal | Half page down / up |
| `%` | Normal | Jump to matching bracket |
| `Alt+Right` | Normal, Insert | Move word forward |
| `Alt+Left` | Normal, Insert | Move word backward |
| `;` | Normal | Enter command mode (alias for `:`) |

### Buffers & Windows

| Key | Mode | Action |
|-----|------|--------|
| `Alt+N` | Normal | Next buffer |
| `Alt+P` | Normal | Previous buffer |
| `Alt+W` | Normal | Close buffer (opens NvimTree if last buffer) |
| `Alt+A` | Normal, Terminal | Cycle to next window |
| `Alt+Z` | Normal, Insert, Terminal | Toggle fullscreen for current window |

### File Explorer

| Key | Mode | Action |
|-----|------|--------|
| `Alt+E` | Normal | Toggle file explorer (nvim-tree) |
| `Ctrl+N` | Normal (in tree) | Create new file/folder |
| `:Tree` | Command | Alias for `NvimTreeToggle` |

### Terminal

| Key | Mode | Action |
|-----|------|--------|
| `Alt+T` | Normal, Insert, Visual, Terminal | Toggle floating terminal |
| `Esc` | Terminal | Exit terminal mode |
| `Alt+C` | Normal, Terminal | Toggle Claude Code terminal (persistent vsplit) |

### Build & Run

| Key | Mode | Action |
|-----|------|--------|
| `Alt+R` | Normal, Insert, Visual, Terminal | Smart compile & run (uses Makefile if present) |
| `F7` | Normal, Insert | Write + `make && make clean` |
| `F6` | Normal, Insert | Lint: `norminette` for C/C++, `flake8` for Python |
| `Alt+S` | Normal, Insert | Save file |
| `Alt+H` | Normal, Insert | Insert file header (42 Stdheader for C/C++, shebang for Python) |

**Alt+R smart logic:**
- **C** — runs `cc -Wall -Werror -Wextra <file> -o a.out && ./a.out`, or `make` if a Makefile exists
- **Python** — runs `python3 <file>`, or `make run` if a Makefile exists

### Python Venv

| Key | Mode | Action |
|-----|------|--------|
| `Alt+V` | Normal, Terminal | Toggle Python venv (auto-finds `.venv` / `venv` / `env`) |

### Editing

| Key | Mode | Action |
|-----|------|--------|
| `Alt+J` | Visual | Move selected block down |
| `Alt+K` | Visual | Move selected block up |
| `jj` | Insert | Escape to normal mode |
| `Ctrl+Up` | Normal, Insert, Visual | Add cursor above |
| `Ctrl+Down` | Normal, Insert, Visual | Add cursor below |
| `Ctrl+LeftMouse` | Normal, Insert | Add/remove cursor at click |
| `Space+a` | Normal, Visual | Add cursors at all matches |
| `Space+d` / `Alt+D` | Normal, Visual | Add cursor at next match |
| `Ctrl+D` | Normal, Visual | vim-visual-multi select under cursor |

### Auto-pairs (Insert Mode)

| Shortcut | Expands to |
|----------|-----------|
| `$1` | `{`  `}` with cursor on new line inside |
| `$4` | `{}` with cursor inside |
| `$6` | `()` with cursor inside |
| `$3` | `[]` with cursor inside |
| `$q` | `''` with cursor inside |
| `$e` | `""` with cursor inside |
| `$2` | `#include ""` with cursor inside quotes |

### Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `Tab` | Select next completion item / expand snippet |
| `Shift+Tab` | Select prev completion item / jump back in snippet |
| `Enter` | Confirm selection |
| `Ctrl+E` | Abort completion |

### Copilot

| Key | Action |
|-----|--------|
| `Ctrl+Y` | Accept full suggestion |
| `Ctrl+L` | Accept current line |
| `Ctrl+Right` | Accept next word |
| `Alt+]` | Next suggestion |
| `Alt+[` | Previous suggestion |
| `Ctrl+]` | Dismiss suggestion |
| `Alt+Enter` | Open panel |
| `[[` / `]]` | Jump prev / next in panel |
| `gr` | Refresh panel |

### Telescope

| Key | Mode | Action |
|-----|------|--------|
| `Alt+F` | Normal | Fuzzy find in current buffer |

### Cheatsheet

| Key / Command | Action |
|---------------|--------|
| `:Cheatsheet` or `:cheatsheet` | Open keybind cheatsheet popup |
| `q` / `Esc` (in popup) | Close the cheatsheet |

## LSP

LSP is lazy-loaded for `c`, `cpp`, and `python` filetypes.

| Language | Server |
|----------|--------|
| C / C++ | `clangd` |
| Python | `pyright` |

Standard LSP keybindings from Neovim apply (`gd`, `K`, `gr`, etc.).

## Autocmds

- **Auto-reload** — files changed externally are reloaded on focus or buffer enter (also polled every second), useful when Claude Code edits files in the background
- **Auto-save** — buffers are written automatically when leaving them (named, non-special buffers only)
- **Terminal fix** — `i` and `a` in normal mode inside terminal buffers enter insert mode correctly

## Options

| Option | Value | Description |
|--------|-------|-------------|
| `clipboard` | `unnamedplus` | System clipboard integration |
| `number` | `true` | Line numbers |
| `wrap` | `false` | No line wrapping |
| `mouse` | `a` | Mouse support in all modes |
| `termguicolors` | `true` | True color support |
| `swapfile` | `false` | No swap files |
| `backup` | `false` | No backup files |
| `timeoutlen` | `300ms` | Fast leader key response |
| `autoread` | `true` | Auto-reload externally changed files |
| `confirm` | `true` | Prompt before unsaved exit |
| `hidden` | `true` | Keep buffers open in background |
