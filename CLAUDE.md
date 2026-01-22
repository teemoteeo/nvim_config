# CLAUDE.md - Neovim Configuration Guide for AI Assistants

**Last Updated**: 2026-01-22
**Configuration Type**: Neovim Lua Configuration (42 School Edition)
**Total Size**: ~246 lines across 11 files
**Plugin Manager**: lazy.nvim

---

## Table of Contents

1. [Repository Overview](#repository-overview)
2. [Directory Structure](#directory-structure)
3. [Plugin Architecture](#plugin-architecture)
4. [Keybindings Reference](#keybindings-reference)
5. [Development Workflows](#development-workflows)
6. [Conventions & Patterns](#conventions--patterns)
7. [AI Assistant Guidelines](#ai-assistant-guidelines)
8. [Known Issues & Dependencies](#known-issues--dependencies)

---

## Repository Overview

This is a modular Neovim configuration designed for **42 School** students, optimized for C/C++ development with support for multiple programming languages. The configuration emphasizes:

- Clean, modular architecture
- Efficient keybindings for coding workflows
- Integration with 42 School tools (norminette, stdheader)
- Multi-language compilation and execution
- AI-powered code completion (Codeium)

### Key Features
- ✅ Modular plugin management with lazy.nvim
- ✅ Custom compile/run functions for 7 languages
- ✅ 42 School tooling integration
- ✅ File explorer (nvim-tree)
- ✅ Modern status line (lualine)
- ✅ AI completion (Codeium)
- ⚠️ **Incomplete**: LSP configuration (plugins installed but not configured)
- ⚠️ **Missing**: Autocommand setup (placeholder only)

---

## Directory Structure

```
/home/user/nvim_config/
├── init.lua                    # Main entry point (8 lines)
├── lazy-lock.json              # Plugin version lockfile (do not edit manually)
├── .gitignore                  # Git ignore rules
└── lua/
    ├── config/                 # Core configuration modules
    │   ├── options.lua         # Vim options (15 lines)
    │   ├── keymaps.lua         # Key mappings + custom functions (68 lines)
    │   └── autocmds.lua        # Autocommands (1 line - placeholder)
    └── plugins/                # Plugin specifications
        ├── init.lua            # Plugin loader + lazy.nvim bootstrap (20 lines)
        ├── cmp.lua             # Completion plugins (4 lines)
        ├── lualine.lua         # Status line config (22 lines)
        ├── codeium.lua         # AI completion (7 lines)
        ├── colorschemes.lua    # Color schemes (52 lines)
        ├── treesitter.lua      # Syntax highlighting (4 lines)
        └── ui.lua              # UI enhancements (45 lines)
```

### File Purposes

| File | Purpose | Status |
|------|---------|--------|
| `init.lua` | Entry point, loads all modules | Complete |
| `lua/config/options.lua` | Editor settings (numbers, mouse, colors) | Complete |
| `lua/config/keymaps.lua` | All keybindings + utility functions | Complete |
| `lua/config/autocmds.lua` | Event handlers | **Empty** |
| `lua/plugins/init.lua` | Plugin manager bootstrap | Complete |
| `lua/plugins/colorschemes.lua` | 4 color schemes (kanagawa active) | Complete |
| `lua/plugins/lualine.lua` | Status line configuration | Complete |
| `lua/plugins/cmp.lua` | Completion plugin declarations | **Not configured** |
| `lua/plugins/treesitter.lua` | Syntax highlighting | Minimal |
| `lua/plugins/ui.lua` | nvim-tree, buffertabs, etc. | Complete |
| `lua/plugins/codeium.lua` | AI code completion | Complete |

---

## Plugin Architecture

### Plugin Manager: lazy.nvim

**Bootstrap Location**: `lua/plugins/init.lua`

The configuration auto-installs lazy.nvim on first run and loads plugin specifications from modular files.

### Installed Plugins (18 total)

#### Core Infrastructure
- `folke/lazy.nvim` - Plugin manager
- `nvim-lua/plenary.nvim` - Lua utility library (dependency)

#### UI/Visual
- `nvim-lualine/lualine.nvim` - Status line
- `Mr-LLLLL/BufferTabs.nvim` - Buffer tabs
- `nvim-tree/nvim-tree.lua` - File explorer
- `nvim-tree/nvim-web-devicons` - File icons
- `sontungexpt/stcursorword` - Highlight word under cursor

#### Editing
- `brenton-leighton/multiple-cursors.nvim` - Multiple cursor support
- `Mr-LLLLL/nvim-luxterm` - Terminal integration

#### Syntax & Parsing
- `nvim-treesitter/nvim-treesitter` - Advanced syntax highlighting

#### Completion & AI
- `hrsh7th/nvim-cmp` - Completion engine (NOT CONFIGURED)
- `hrsh7th/cmp-nvim-lsp` - LSP completion source (NOT CONFIGURED)
- `Exafunction/codeium.nvim` - AI code completion ✅

#### Color Schemes
- `rebelot/kanagawa.nvim` (Active - dragon variant)
- `shaunsingh/nord.nvim`
- `savq/melange-nvim`
- `scottmckendry/cyberdream.nvim`

### Plugin Loading Strategy

Plugins are organized by category:
```lua
require("lazy").setup({
  require("plugins.colorschemes"),    # Color schemes (lazy-loaded except active)
  require("plugins.lualine"),         # Status line
  require("plugins.treesitter"),      # Syntax highlighting
  require("plugins.cmp"),             # Completion framework
  require("plugins.ui"),              # UI enhancements
  require("plugins.codeium"),         # AI completion
})
```

---

## Keybindings Reference

**Leader Key**: `Space`

### Core Navigation

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `;` | `:` | Quick command mode |
| Normal | `<C-D>` | `<C-D>zz` | Scroll down & center |
| Normal | `<C-S>` | `<C-B>zz` | Scroll up & center (maps to Ctrl+B) |
| Insert | `jj` | `<Esc>` | Quick escape |
| Normal | `<C-N>` | `:bnext` | Next buffer |
| Normal | `<C-P>` | `:bprev` | Previous buffer |

### Auto-pairs (Insert Mode)

| Key | Result | Use Case |
|-----|--------|----------|
| `$6` | `()` | Parentheses |
| `$2` | `#include ""` | C include statement |
| `$3` | `[]` | Brackets |
| `$4` | `{}` | Braces (inline) |
| `$1` | `{\n}\n` | Braces (block with newline) |
| `$q` | `''` | Single quotes |
| `$e` | `""` | Double quotes |

### Function Keys (42 School Workflow)

| Key | Action | Description |
|-----|--------|-------------|
| `F1` | `:Stdheader` | Insert 42 header |
| `F5` | `CompileRun()` | Compile & run current file |
| `F6` | `normcheck()` | Run norminette (42 style checker) |
| `F7` | `wmake()` | Write → Make → Run workflow |

### Leader Mappings

| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>e` | `:NvimTreeToggle` | Toggle file explorer |

### Multiple Cursors

| Key | Action |
|-----|--------|
| `<C-Up>` | Add cursor above |
| `<C-Down>` | Add cursor below |
| `<C-LeftMouse>` | Add/remove cursor at mouse position |
| `<Leader>a` | Add cursors to all matches |
| `<Leader>d` | Jump to next match and add cursor |

---

## Development Workflows

### Custom Functions

Three custom utility functions are defined in `lua/config/keymaps.lua`:

#### 1. CompileRun() - Multi-language Compiler/Runner

**Trigger**: F5 key

Automatically detects filetype and compiles/runs accordingly:

```lua
C         → gcc % get_next_line_utils.c -o a.out && valgrind --leak-check=full -s ./a.out
C++       → g++ % -o %< && time ./%<
Java      → javac % && time java %
Shell     → time bash %
Python    → time python3 %
Go        → go build %< && time go run %
MATLAB    → time octave %
```

**⚠️ Important**: Hardcodes `get_next_line_utils.c` in C compilation (42 project specific)

#### 2. normcheck() - 42 Style Checker

**Trigger**: F6 key

Saves current file and runs norminette for style checking.

#### 3. wmake() - Automated Build Workflow

**Trigger**: F7 key

**Workflow**:
1. Save current file
2. Run `make`
3. If `main.c` exists, open it
4. Execute `CompileRun()`

**Use Case**: Standard 42 project workflow automation

---

## Conventions & Patterns

### File Naming Conventions

- **All lowercase** filenames
- **Descriptive names** matching purpose
- **Singular** for configuration: `options.lua`
- **Plural** for collections: `keymaps.lua`, `autocmds.lua`
- **Plugin names/abbreviations**: `cmp.lua`, `lualine.lua`
- **Category grouping**: `ui.lua` groups related UI plugins

### Code Organization Patterns

#### Modular Structure
```
init.lua → config/* → plugins/* → individual plugin configs
```

#### Plugin Declaration Patterns

**Simple (no config)**:
```lua
return {
  { "author/plugin-name" }
}
```

**With inline setup**:
```lua
return {
  "author/plugin-name",
  config = function()
    require("plugin").setup({
      -- configuration
    })
  end,
}
```

**With lazy loading**:
```lua
return {
  "author/plugin-name",
  lazy = true,  # Don't load on startup
  event = "VeryLazy",  # Or other trigger
}
```

**Primary theme pattern**:
```lua
{
  "author/theme",
  lazy = false,      # Load immediately
  priority = 1000,   # Load before other plugins
  config = function()
    vim.cmd.colorscheme("theme-name")
  end,
}
```

### Separation of Concerns

| Concern | Location |
|---------|----------|
| Editor behavior | `config/options.lua` |
| Key mappings | `config/keymaps.lua` |
| Custom functions | `config/keymaps.lua` (same file as mappings) |
| Event handlers | `config/autocmds.lua` (currently empty) |
| Plugin bootstrap | `plugins/init.lua` |
| Plugin configs | `plugins/*.lua` (one file per plugin or category) |

---

## AI Assistant Guidelines

### When Making Changes

#### 1. File Operations

**Always Read Before Edit**:
- Use `Read` tool before modifying any file
- Never assume file contents

**Prefer Edit Over Write**:
- Use `Edit` tool for existing files
- Only use `Write` for new files

**Preserve Formatting**:
- Match existing indentation (2 spaces for Lua)
- Keep consistent quote style (double quotes preferred)
- Maintain blank line patterns

#### 2. Adding Keybindings

**Location**: `lua/config/keymaps.lua`

**Pattern to follow**:
```lua
vim.keymap.set("mode", "key", "action", { desc = "Description" })
```

**Before adding**:
- Check for conflicts with existing mappings
- Consider if it fits the user's workflow (42 School context)
- Document the purpose clearly

#### 3. Adding Plugins

**Process**:
1. Determine appropriate category
2. Create new file in `plugins/` if needed, or add to existing category file
3. Add require statement to `plugins/init.lua` setup call
4. Follow lazy.nvim specification format
5. Add dependencies if required

**Example**:
```lua
-- In plugins/newplugin.lua
return {
  "author/plugin-name",
  dependencies = { "required/dependency" },
  config = function()
    require("plugin-name").setup({
      -- configuration
    })
  end,
}

-- Add to plugins/init.lua:
require("lazy").setup({
  -- ... existing plugins ...
  require("plugins.newplugin"),
})
```

#### 4. Modifying Options

**Location**: `lua/config/options.lua`

**Current options**:
```lua
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
```

**When adding**:
- Group related options together
- Add comment if purpose is not obvious
- Use `vim.opt` for options, `vim.g` for globals

#### 5. Adding Autocommands

**Location**: `lua/config/autocmds.lua`

**⚠️ Currently empty** - this is a good area for expansion

**Pattern to follow**:
```lua
-- Create augroup for organization
local augroup = vim.api.nvim_create_augroup("GroupName", { clear = true })

-- Add autocommand
vim.api.nvim_create_autocmd("Event", {
  group = augroup,
  pattern = "pattern",
  callback = function()
    -- action
  end,
})
```

#### 6. Modifying Custom Functions

**Location**: `lua/config/keymaps.lua` (bottom of file)

**Existing functions**:
- `CompileRun()` - Multi-language compiler
- `normcheck()` - Style checker
- `wmake()` - Build workflow

**When modifying `CompileRun()`**:
- **⚠️ CRITICAL**: The hardcoded `get_next_line_utils.c` is project-specific
- Ask user before removing this reference
- Maintain the auto-save behavior
- Keep the time measurement for user feedback

### LSP Configuration (Incomplete Area)

**Current State**:
- `nvim-cmp` installed but NOT configured
- No LSP server setup exists
- No completion keybindings defined

**If asked to configure LSP**:
1. Install required plugins:
   - `neovim/nvim-lspconfig`
   - `williamboman/mason.nvim`
   - `williamboman/mason-lspconfig.nvim`
   - `L3MON4D3/LuaSnip` (snippet engine)
   - `saadparwaiz1/cmp_luasnip`

2. Create `lua/plugins/lsp.lua` for LSP configuration
3. Configure `nvim-cmp` in `lua/plugins/cmp.lua`
4. Add completion keybindings

**Recommended LSP servers for 42 School**:
- `clangd` (C/C++)
- `pyright` (Python)
- `lua_ls` (Lua)

### Testing Changes

**After any modification**:
1. Source the configuration: `:source %` (if in Neovim)
2. Check for errors: `:messages`
3. Test affected functionality
4. Verify keybindings work: `:map <key>`

### Common Tasks

#### Change Color Scheme

**Location**: `lua/plugins/colorschemes.lua`

Change which theme has `lazy = false` and `priority = 1000`:
```lua
{
  "rebelot/kanagawa.nvim",
  lazy = false,  -- Currently active
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
},
{
  "shaunsingh/nord.nvim",
  lazy = true,  -- Not loaded by default
},
```

#### Add New Language to CompileRun()

**Location**: `lua/config/keymaps.lua`

Add new `elseif` block:
```lua
elseif vim.bo.filetype == "newlang" then
  vim.cmd("!compiler % && runner %<")
```

#### Add File Explorer Keybinding

File explorer (nvim-tree) is already configured. Keybinding:
- `<Leader>e` toggles nvim-tree

Additional nvim-tree keybindings can be added in `lua/plugins/ui.lua`

---

## Known Issues & Dependencies

### External Dependencies

**⚠️ Not in Repository**:
- `~/stdheader.vim` - 42 header script (referenced in init.lua:2)
- `~/gdb.vim` - GDB integration script (referenced in init.lua:3)

**System Tools Required**:
- `norminette` - 42 style checker (used by F6)
- `valgrind` - Memory checker (used in C compilation)
- `gcc`, `g++` - C/C++ compilers
- `python3`, `bash`, `java`, `go`, `octave` - Language runtimes

### Incomplete Features

1. **LSP Configuration**: Plugins installed but not configured
2. **Autocommands**: Placeholder file exists but no autocommands defined
3. **Completion Sources**: Only LSP source declared, missing buffer, path, cmdline sources
4. **No Snippet Engine**: Required for full nvim-cmp functionality

### Hardcoded Values

**⚠️ Review before modifying**:
1. `get_next_line_utils.c` in CompileRun() - Project-specific file
2. `~/stdheader.vim` path - User's home directory
3. `~/gdb.vim` path - User's home directory

### Git Configuration

**Branch**: `claude/claude-md-mkq20m7ajo5rhfwo-ygV6H`
**Status**: Clean working tree
**Last Commit**: `71891d7 Initial upload of nvim config`

**When committing changes**:
- Follow commit message style (concise, imperative)
- Never commit external vim scripts (not in repo)
- lazy-lock.json is tracked (plugin versions)

---

## Quick Reference for AI Assistants

### File Modification Checklist

- [ ] Read file first with `Read` tool
- [ ] Use `Edit` tool for existing files
- [ ] Match existing indentation (2 spaces)
- [ ] Test changes if possible
- [ ] Check for keybinding conflicts
- [ ] Document complex additions

### Plugin Addition Checklist

- [ ] Determine appropriate category/file
- [ ] Check for existing similar functionality
- [ ] Add to correct plugins/*.lua file
- [ ] Update plugins/init.lua if new file created
- [ ] Include dependencies if required
- [ ] Add configuration in `config = function()` if needed

### When Uncertain

**Ask the user about**:
- Modifying hardcoded project-specific references
- Removing external script dependencies
- Major structural changes
- LSP server preferences
- Color scheme changes

**Safe to proceed**:
- Adding new keybindings (if no conflicts)
- Adding autocommands (file is empty)
- Improving existing functions (with care)
- Adding plugins that fit existing patterns
- Documentation improvements

---

## Additional Context

### Educational Context: 42 School

This configuration is optimized for 42 School projects:
- C/C++ focus with norminette integration
- Valgrind memory checking
- 42 header insertion (stdheader)
- Project-specific compilation patterns

**When suggesting changes**: Consider if they align with 42 workflow requirements.

### Configuration Philosophy

**Strengths**:
- Clean modular structure
- Practical keybindings
- Multi-language support
- Good plugin organization

**Areas for Growth**:
- Complete LSP setup
- Add useful autocommands
- Expand completion sources
- Add more language-specific configurations

---

**End of CLAUDE.md**

*This file should be updated when major structural changes are made to the configuration.*
