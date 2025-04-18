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

echo "===== Neovim Complete Installation Script ====="
echo "This script will install the following components:"
echo "1. GCC compiler (required for some Neovim plugins)"
echo "2. Neovim (latest version from GitHub, with option to skip)"
echo "3. JetBrainsMono and Mononoki Nerd Fonts"
echo "4. Optional packages (kitty, fzf, ripgrep, fd-find, curl, xclip)"
echo "5. Mason dependencies (Python, npm, etc.)"
echo "6. Copy Neovim configuration files (optional)"
echo ""
echo "Each component will ask for confirmation before installation."
echo ""

# Check if the required scripts exist
for script in "./install_neovim.sh" "./install_nerdfonts.sh" "./install_optional_packages.sh" "./uninstall_neovim.sh" "./copy_neovim_into_config.sh" "./install_mason_dependencies.sh" "./install_gcc.sh"; do
  if [ ! -f "$script" ]; then
    error "Required script $script not found. Make sure all installation scripts are in the current directory."
  fi
done

# Make all scripts executable
chmod +x ./*.sh
success "All scripts are now executable."

# Ask for confirmation
read -p "Do you want to start the installation process? (y/n): " choice
if [[ ! "$choice" =~ ^[Yy]$ ]]; then
  echo "Installation aborted."
  exit 0
fi

# Check and install GCC if needed
echo ""
echo "=== Step 1/6: Checking for GCC compiler ==="
./install_gcc.sh
if [ $? -ne 0 ]; then
  error "GCC installation check failed. Aborting."
fi

# Install Neovim (or skip based on user choice in install_neovim.sh)
echo ""
echo "=== Step 2/6: Installing Neovim ==="
./install_neovim.sh
NEOVIM_EXIT_CODE=$?
if [ $NEOVIM_EXIT_CODE -eq 0 ]; then
  echo "Neovim installation step completed."
else
  error "Neovim installation failed with exit code $NEOVIM_EXIT_CODE. Aborting."
fi

# Install Nerd Fonts
echo ""
echo "=== Step 3/6: Installing Nerd Fonts ==="
./install_nerdfonts.sh
if [ $? -ne 0 ]; then
  error "Nerd Fonts installation failed. Aborting."
fi

# Install Optional Packages
echo ""
echo "=== Step 4/6: Installing Optional Packages ==="
./install_optional_packages.sh
if [ $? -ne 0 ]; then
  error "Optional packages installation failed. Aborting."
fi

# Install Mason Dependencies
echo ""
echo "=== Step 5/6: Installing Mason Dependencies ==="
./install_mason_dependencies.sh
if [ $? -ne 0 ]; then
  error "Mason dependencies installation failed. Aborting."
fi

# Copy Neovim Configuration Files
echo ""
echo "=== Step 6/6: Copying Neovim Configuration Files ==="
read -p "Do you want to install the custom Neovim configuration? (y/n): " config_choice
if [[ "$config_choice" =~ ^[Yy]$ ]]; then
  ./copy_neovim_into_config.sh
  if [ $? -ne 0 ]; then
    error "Neovim configuration installation failed. Aborting."
  fi
else
  echo "Skipping Neovim configuration installation."
fi

success "Installation process completed successfully!"

echo ""
echo "If you need to uninstall Neovim in the future, you can use the included uninstall_neovim.sh script."
echo "Remember to set your terminal font to one of the installed Nerd Fonts for proper icon display!"
