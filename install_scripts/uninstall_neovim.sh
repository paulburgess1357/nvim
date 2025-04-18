#!/bin/bash

# Neovim Uninstaller Script
echo "===== Neovim Uninstaller ====="
echo "This script will uninstall Neovim that was installed from source."
echo

# Check common installation locations
POSSIBLE_LOCATIONS=(
    "/usr/local/bin/nvim"
    "/usr/bin/nvim"
    "/opt/nvim/bin/nvim"
    "$HOME/.local/bin/nvim"
)

FOUND=false
for loc in "${POSSIBLE_LOCATIONS[@]}"; do
    if [ -f "$loc" ]; then
        echo "Found Neovim binary at: $loc"
        NVIM_PATH="$loc"
        FOUND=true
        break
    fi
done

if ! $FOUND; then
    echo "Neovim binary not found in common locations."
    # Check where the shell thinks nvim is
    SHELL_PATH=$(command -v nvim 2>/dev/null)
    if [ -n "$SHELL_PATH" ]; then
        echo "Shell reports Neovim at: $SHELL_PATH (but file may not exist)"
        NVIM_PATH="$SHELL_PATH"
    else
        echo "Neovim doesn't appear to be properly installed."
        echo "Your shell is trying to run it from /usr/local/bin/nvim but that file doesn't exist."
        echo "This usually happens when the binary was deleted but the shell's path cache wasn't updated."
    fi
fi

# Ask for confirmation
read -p "Do you want to clean up Neovim installations and references? (y/n): " choice
if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "Uninstallation aborted."
    exit 0
fi

# Clean up any references to nvim
echo "Cleaning up Neovim installations..."
sudo rm -f /usr/local/bin/nvim
sudo rm -f /usr/bin/nvim
sudo rm -f /opt/nvim/bin/nvim
rm -f $HOME/.local/bin/nvim

# Also remove related binaries
echo "Removing related Neovim binaries..."
sudo rm -f /usr/local/bin/nvim-*
sudo rm -f /usr/bin/nvim-*

# Remove shared data
echo "Removing shared Neovim data..."
sudo rm -rf /usr/local/share/nvim/
sudo rm -rf /usr/share/nvim/

# Ask about configuration files
read -p "Do you also want to remove your personal Neovim configuration? (y/n): " config_choice
if [[ "$config_choice" =~ ^[Yy]$ ]]; then
    echo "Removing personal configuration..."
    rm -rf ~/.config/nvim/
    rm -rf ~/.local/share/nvim/
    rm -rf ~/.cache/nvim/
    echo "Personal configuration removed."
else
    echo "Keeping personal configuration."
fi

# Reset shell's hash table
echo "Resetting shell's command hash table..."
hash -r

echo "Uninstallation process completed."
echo "You may need to restart your terminal session for changes to take effect completely."
