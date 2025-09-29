#!/bin/bash

# ACVim Avante.nvim Setup Script
# This script helps configure the API key for Avante.nvim

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[ACVim Avante]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[ACVim Avante]${NC} ✅ $1"
}

print_warning() {
    echo -e "${YELLOW}[ACVim Avante]${NC} ⚠️  $1"
}

print_error() {
    echo -e "${RED}[ACVim Avante]${NC} ❌ $1"
}

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║         ACVim Avante.nvim Setup           ║"
echo "║     AI-Powered Coding Assistant Setup      ║"
echo "╚════════════════════════════════════════════╝"
echo ""

print_status "Setting up Avante.nvim for ACVim..."
echo ""

# Check if API key is already set
if [ -n "$ANTHROPIC_API_KEY" ]; then
    print_success "ANTHROPIC_API_KEY is already set in your environment"
    echo ""
    echo "To use a different key, you can:"
    echo "  1. Export a new key: export ANTHROPIC_API_KEY='your-new-key'"
    echo "  2. Add it to your shell config file"
else
    print_warning "ANTHROPIC_API_KEY is not set"
    echo ""
    echo "To use Avante.nvim with Claude, you need to set your API key:"
    echo ""
    echo "1. Get your API key from: https://console.anthropic.com/settings/keys"
    echo ""
    echo "2. Add this line to your shell configuration file:"
    echo "   For zsh (~/.zshrc):"
    echo "     export ANTHROPIC_API_KEY='your-api-key-here'"
    echo ""
    echo "   For bash (~/.bashrc or ~/.bash_profile):"
    echo "     export ANTHROPIC_API_KEY='your-api-key-here'"
    echo ""
    echo "3. Reload your shell configuration:"
    echo "     source ~/.zshrc  # or ~/.bashrc"
    echo ""
fi

echo "🎯 Avante.nvim Keybindings:"
echo "   <leader>aa      - Ask AI assistant"
echo "   <leader>ae      - Edit with AI"
echo "   <leader>at      - Toggle AI sidebar"
echo "   <leader>ar      - Refresh AI response"
echo "   Ctrl+Alt+A      - Quick toggle AI sidebar"
echo ""
echo "   In visual mode:"
echo "   <leader>aa      - Ask about selected code"
echo "   <leader>ae      - Edit selected code"
echo ""
echo "📖 Commands (via Ctrl+P command palette):"
echo "   :AvanteAsk      - Ask a question"
echo "   :AvanteEdit     - Edit code"
echo "   :AvanteToggle   - Toggle sidebar"
echo "   :AvanteRefresh  - Refresh response"
echo "   :AvanteClear    - Clear conversation"
echo ""
echo "💡 Tips:"
echo "   - Select code and press <leader>aa to ask about it"
echo "   - Use <leader>ae to request code edits"
echo "   - The AI sidebar shows on the right side"
echo "   - Use Tab/Shift+Tab to switch between windows"
echo ""

if [ -n "$ANTHROPIC_API_KEY" ]; then
    print_success "Avante.nvim is ready to use!"
else
    print_warning "Remember to set your ANTHROPIC_API_KEY before using Avante.nvim"
fi

echo ""