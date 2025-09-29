# Changelog

All notable changes to ACVim will be documented in this file.

## [1.0.0] - 2024-01-XX

### Added
- Initial ACVim release based on ModelessVim
- VS Code-style keybindings (Ctrl+C/V, Ctrl+Z/Y, Ctrl+S, etc.)
- Isolated Neovim configuration (doesn't conflict with regular nvim)
- System-wide `acvim` command installation
- Comprehensive plugin ecosystem:
  - Legendary.nvim for command palette (Ctrl+P, Ctrl+O)
  - Telescope.nvim for file finding and text search
  - Nvim-tree file explorer with mouse support
  - Catppuccin colorscheme
- Smart text selection and replacement behavior
- Line numbers in telescope previews
- Custom search navigation (Tab/Shift+Tab in search mode)
- Half-screen optimized telescope layouts
- System clipboard integration for macOS
- Startup message suppression for clean launch
- Custom mouse handling for file tree operations
- Smart quit with unsaved file detection
- Preview scrolling with Left/Right arrows (slow) and Ctrl+arrows (fast)

### Features
- **File Operations**: Find, search, save, smart quit
- **Text Editing**: VS Code-style selection, copy/paste, undo/redo
- **Navigation**: File tree, quick file switching, preview navigation
- **Search**: Live grep, current buffer search, match cycling
- **UI**: Clean startup, optimized layouts, line numbers

### Technical Details
- Built on ModelessVim foundation
- Uses Lazy.nvim for plugin management
- Isolated configuration in ~/.config/acvim/
- Separate data directories to avoid conflicts
- Custom keybinding overrides for ModelessVim behaviors

### Installation
- Automated installation script
- Manual installation instructions
- Cross-platform support (macOS tested)
- PATH configuration assistance