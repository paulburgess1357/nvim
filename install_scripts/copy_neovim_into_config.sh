#!/bin/bash
# Function to display error messages
error() {
  echo -e "\e[31mERROR: $1\e[0m" >&2
  exit 1
}
# Function to display success messages
success() {
  echo -e "\e[32m$1\e[0m"
}
# Function to display information messages
info() {
  echo -e "\e[34m$1\e[0m"
}

# Destination directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Find the repository directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Check if this script is in a subdirectory of the repo
if [[ "${SCRIPT_DIR##*/}" == "install_scripts" ]]; then
  REPO_DIR="$(dirname "$SCRIPT_DIR")"
else
  # Otherwise assume we're directly in the repo
  REPO_DIR="$SCRIPT_DIR"
fi

# Create a timestamp for backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.config/nvim_backup_$TIMESTAMP"

echo "===== Neovim Configuration Installation ====="
echo "This script will copy the Neovim configuration files to $NVIM_CONFIG_DIR"
echo

# Check if Neovim config directory already exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
  info "Neovim configuration directory already exists at $NVIM_CONFIG_DIR"
  # Ask if the user wants to create a backup
  read -p "Do you want to create a backup of your existing Neovim configuration? (y/n): " backup_choice
  if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
    echo "Creating backup at $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$NVIM_CONFIG_DIR/"* "$BACKUP_DIR" 2>/dev/null
    cp -r "$NVIM_CONFIG_DIR/".* "$BACKUP_DIR" 2>/dev/null
    success "Backup created successfully at $BACKUP_DIR"
  else
    echo "No backup will be created."
  fi

  # Ask if the user wants to overwrite existing configuration
  read -p "Do you want to overwrite your existing Neovim configuration? (y/n): " overwrite_choice
  if [[ ! "$overwrite_choice" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled. Your Neovim configuration remains unchanged."
    exit 0
  fi

  # Remove existing configuration
  echo "Removing existing configuration..."
  rm -rf "$NVIM_CONFIG_DIR"
fi

# Create the Neovim config directory
mkdir -p "$NVIM_CONFIG_DIR"

# Simple and direct copy command
echo "Copying repository to $NVIM_CONFIG_DIR..."
cp -r "$REPO_DIR/"* "$NVIM_CONFIG_DIR/"
cp -r "$REPO_DIR/".* "$NVIM_CONFIG_DIR/" 2>/dev/null || true

success "Neovim configuration installed successfully!"
echo
echo "Your Neovim configuration has been set up at: $NVIM_CONFIG_DIR"
if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
  echo "A backup of your previous configuration is available at: $BACKUP_DIR"
fi
echo "You can now start Neovim with 'nvim' command to use your new configuration."
