#!/bin/bash

# Function to check if GCC is installed
check_gcc_installed() {
  if ! command -v gcc &>/dev/null; then
    echo "GCC is not installed on your system."
    read -p "Do you want to install GCC? (y/n): " choice
    case "$choice" in
    y | Y)
      echo "Installing GCC..."
      sudo apt install -y gcc
      echo "GCC installed successfully."
      ;;
    *)
      echo "Skipping GCC installation. Note that GCC is required for some Neovim plugins."
      ;;
    esac
  else
    echo "GCC is already installed."
    # Display the installed version for information
    gcc_version=$(gcc --version | head -n 1)
    echo "Current version: $gcc_version"
  fi
}

# Header
echo "===== GCC Installation Check ====="
echo "This script will check if GCC is installed on your system."
echo

# Check if GCC is installed
check_gcc_installed

echo
echo "GCC check completed."
