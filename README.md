# ACVim

**ACVim** is a custom Neovim fork based on ModelessVim that provides VS Code-style keybindings and behaviors with a comprehensive plugin ecosystem. It's designed to give you the power of Neovim with familiar editor shortcuts and modern features.

## Features

### Core Functionality
- **VS Code-style keybindings**: Ctrl+C/V, Ctrl+Z/Y, Ctrl+S, Shift+Arrow selection, etc.
- **Isolated configuration**: Doesn't conflict with your regular Neovim setup
- **ModelessVim base**: Built on the ModelessVim foundation for familiar editing
- **System-wide installation**: Available via `acvim` command

### Plugin Ecosystem
- **🎯 Legendary.nvim**: VS Code-style command palette (Ctrl+P, Ctrl+O)
- **🔍 Telescope.nvim**: Fast file finding and text search with preview
- **🌳 Nvim-tree**: File explorer with mouse support
- **🎨 Catppuccin**: Beautiful colorscheme
- **📋 System clipboard integration**: Seamless copy/paste with macOS

### Advanced Features
- **Half-screen optimized layouts**: Telescope configured for efficient screen usage
- **Line numbers in previews**: Easy navigation with line references
- **Smart text selection**: Replace selected text by typing
- **Custom search navigation**: Tab/Shift+Tab to cycle through matches
- **Mouse-friendly interface**: Single-click file operations
- **Startup message suppression**: Clean, distraction-free startup

## Installation

### Prerequisites
- Neovim (latest stable version recommended)
- Git
- A Nerd Font (Hack Nerd Font recommended)
- macOS (tested platform)

### Quick Install
```bash
# Clone the repository
git clone https://github.com/yourusername/acvim.git
cd acvim

# Run the installation script
./install.sh
```

### Manual Installation
1. Copy the launcher script to your PATH:
   ```bash
   cp acvim ~/.local/bin/
   chmod +x ~/.local/bin/acvim
   ```

2. Create the ACVim configuration directory:
   ```bash
   mkdir -p ~/.config/acvim
   cp config/init.lua ~/.config/acvim/
   ```

3. Add `~/.local/bin` to your PATH if not already added:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

## Usage

### Starting ACVim
```bash
acvim [file]
```

### Key Bindings

#### File Operations
- `Ctrl+O` - File finder (with file preview)
- `Ctrl+P` - Command palette
- `Ctrl+F` - Search text across all files
- `Ctrl+S` - Save file
- `Ctrl+Q` - Smart quit (prompts for unsaved changes)
- `Ctrl+B` - Toggle file explorer

#### Editing
- `Ctrl+A` - Select all
- `Ctrl+C` - Copy (line or selection)
- `Ctrl+V` - Paste
- `Ctrl+Z` - Undo
- `Ctrl+Y` - Redo
- `Shift+Arrow Keys` - Text selection
- `Ctrl+Shift+Arrow Keys` - Word selection

#### Navigation
- `Ctrl+Left/Right` - Focus file tree/editor
- `/` then `Tab/Shift+Tab` - Cycle through search matches while typing

#### Preview Navigation (in Telescope)
- `Left/Right Arrow` - Scroll preview (1 line)
- `Ctrl+Left/Right` - Fast scroll preview (5 lines)

## Configuration

ACVim uses an isolated configuration in `~/.config/acvim/init.lua`. This means:
- Your regular Neovim config remains untouched
- ACVim has its own plugin directory and data
- Completely independent installations

### Customization
Edit `~/.config/acvim/init.lua` to customize:
- Keybindings
- Plugin configurations
- Color schemes
- Layout preferences

## Architecture

### Plugin Stack
```
┌─────────────────────────────────────┐
│             ACVim Layer             │
├─────────────────────────────────────┤
│          ModelessVim Base           │
├─────────────────────────────────────┤
│            Neovim Core              │
└─────────────────────────────────────┘
```

### Key Components
- **Lazy.nvim**: Plugin manager with lazy loading
- **Legendary.nvim**: Command palette and keymap management
- **Telescope.nvim**: Fuzzy finder with custom layouts
- **Nvim-tree**: File explorer with mouse integration
- **Custom keybindings**: VS Code-style shortcuts

## Development

### Project Structure
```
acvim/
├── config/
│   └── init.lua          # Main configuration
├── acvim                 # Launcher script
├── install.sh            # Installation script
└── README.md             # This file
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `acvim`
5. Submit a pull request

## Troubleshooting

### Common Issues
- **Command not found**: Ensure `~/.local/bin` is in your PATH
- **Plugin errors**: Run `:checkhealth` in ACVim
- **Telescope issues**: Check layout strategies in config

### Getting Help
- Check `:help` in ACVim
- Review configuration in `~/.config/acvim/init.lua`
- Open an issue on GitHub

## License

MIT License - see LICENSE file for details

## Credits

- Built on [ModelessVim](https://github.com/SebastianMuskalla/ModelessVim)
- Powered by [Neovim](https://neovim.io/)
- Plugin ecosystem by the amazing Neovim community

---

*ACVim: Where Neovim meets modern editor convenience*