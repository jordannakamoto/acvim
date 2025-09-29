#!/bin/bash

# ACVim Installation Script
# This script installs ACVim with isolated configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[ACVim]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[ACVim]${NC} ✅ $1"
}

print_warning() {
    echo -e "${YELLOW}[ACVim]${NC} ⚠️  $1"
}

print_error() {
    echo -e "${RED}[ACVim]${NC} ❌ $1"
}

print_status "Starting ACVim installation..."

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    if ! command -v nvim &> /dev/null; then
        print_error "Neovim is not installed. Please install Neovim first."
        echo "  macOS: brew install neovim"
        echo "  Linux: See https://github.com/neovim/neovim/wiki/Installing-Neovim"
        exit 1
    fi

    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Install optional dependencies
install_dependencies() {
    print_status "Installing optional dependencies..."

    # Check for Homebrew on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            # Install ripgrep if not present (used by telescope)
            if ! command -v rg &> /dev/null; then
                print_status "Installing ripgrep via Homebrew..."
                if brew install ripgrep; then
                    print_success "Ripgrep installed successfully"
                else
                    print_warning "Failed to install ripgrep. You can install it manually with: brew install ripgrep"
                fi
            else
                print_success "Ripgrep already installed"
            fi

            # Install fd if not present (used by telescope)
            if ! command -v fd &> /dev/null; then
                print_status "Installing fd via Homebrew..."
                if brew install fd; then
                    print_success "fd installed successfully"
                else
                    print_warning "Failed to install fd. You can install it manually with: brew install fd"
                fi
            else
                print_success "fd already installed"
            fi
        else
            print_warning "Homebrew not found. Please install optional dependencies manually:"
            echo "  - ripgrep: https://github.com/BurntSushi/ripgrep"
            echo "  - fd: https://github.com/sharkdp/fd"
        fi
    else
        print_warning "Non-macOS system detected. Please install optional dependencies manually:"
        echo "  - ripgrep: https://github.com/BurntSushi/ripgrep"
        echo "  - fd: https://github.com/sharkdp/fd"
        echo ""
        echo "Common package managers:"
        echo "  Ubuntu/Debian: sudo apt install ripgrep fd-find"
        echo "  Fedora: sudo dnf install ripgrep fd-find"
        echo "  Arch: sudo pacman -S ripgrep fd"
    fi

    print_success "Dependencies installation completed"
}

# Create directories
create_directories() {
    print_status "Creating ACVim directories..."

    mkdir -p ~/.local/bin
    mkdir -p ~/.config/acvim
    mkdir -p ~/.local/share/acvim
    mkdir -p ~/.local/state/acvim
    mkdir -p ~/.cache/acvim

    print_success "Directories created"
}

# Install launcher script
install_launcher() {
    print_status "Installing ACVim launcher..."

    if [[ -f "acvim" ]]; then
        cp acvim ~/.local/bin/acvim
        chmod +x ~/.local/bin/acvim
        print_success "Launcher installed to ~/.local/bin/acvim"
    else
        print_error "acvim launcher script not found in current directory"
        exit 1
    fi
}

# Install configuration
install_config() {
    print_status "Installing ACVim configuration..."

    if [[ -f "config/init.lua" ]]; then
        cp config/init.lua ~/.config/acvim/
        print_success "Configuration installed to ~/.config/acvim/"
    else
        print_error "config/init.lua not found"
        exit 1
    fi
}

# Check PATH
check_path() {
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_warning "~/.local/bin is not in your PATH"
        echo ""
        echo "Add the following line to your shell configuration file:"
        echo "  ~/.zshrc (for zsh) or ~/.bashrc (for bash)"
        echo ""
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        echo "Then restart your terminal or run: source ~/.zshrc"
        echo ""
    else
        print_success "PATH is correctly configured"
    fi
}

# Main installation process
main() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║              ACVim Setup              ║"
    echo "║   VS Code-style Neovim Experience     ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""

    check_prerequisites
    install_dependencies
    create_directories
    install_launcher
    install_config
    check_path

    echo ""
    print_success "ACVim installation complete!"
    echo ""
    echo "🚀 Quick Start:"
    echo "   acvim                    # Start ACVim"
    echo "   acvim myfile.txt        # Open a file"
    echo ""
    echo "🎯 Key Features:"
    echo "   Ctrl+O  - File finder"
    echo "   Ctrl+P  - Command palette"
    echo "   Ctrl+F  - Search in files"
    echo "   Ctrl+B  - Toggle file explorer"
    echo ""
    echo "📖 For more information, see README.md"
    echo ""

    if command -v acvim &> /dev/null; then
        print_status "ACVim is ready to use!"
    else
        print_warning "Please restart your terminal or update your PATH to use ACVim"
    fi
}

# Run installation
main "$@"