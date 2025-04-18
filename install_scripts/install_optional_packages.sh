#!/bin/bash
# Define the list of packages we want to manage
PACKAGES=("kitty" "fzf" "ripgrep" "fd-find" "curl" "xclip")
# Function to install a package
install_package() {
  local package=$1
  echo "Installing $package..."
  sudo apt install -y $package
  echo "$package installed successfully."
  # If the installed package is kitty, ask about config file
  if [ "$package" = "kitty" ]; then
    install_kitty_config
  fi
}
# Function to update a package
update_package() {
  local package=$1
  echo "Updating $package..."
  sudo apt install --only-upgrade -y $package
  echo "$package updated successfully."
}
# Function to install kitty config file
install_kitty_config() {
  read -p "Do you want to install the custom kitty config file? (y/n): " config_choice
  case "$config_choice" in
  y | Y)
    echo "Installing kitty config file..."
    # Create .config/kitty directory if it doesn't exist
    mkdir -p ~/.config/kitty
    # Copy the config file from the install scripts directory to the kitty config dir
    cp "$(dirname "$0")/kitty.conf" ~/.config/kitty/kitty.conf
    echo "Kitty configuration file installed successfully."
    ;;
  *)
    echo "Skipping kitty config installation."
    ;;
  esac
}
# Check if a package needs an update
check_update_needed() {
  local package=$1
  # Check if the package can be upgraded
  if apt-get --simulate upgrade $package | grep -q "^Inst $package"; then
    return 0 # Update needed
  else
    return 1 # No update needed
  fi
}
# Check if packages are installed and up to date
check_install() {
  local package=$1
  # Handle xclip specially since it doesn't have a command with the same name
  if [ "$package" = "xclip" ]; then
    if ! dpkg -l | grep -q "^ii.*xclip"; then
      # Package not installed
      read -p "Install $package? (y/n): " choice
      case "$choice" in
      y | Y)
        install_package $package
        ;;
      *)
        echo "Skipping $package installation."
        ;;
      esac
    else
      echo "$package is already installed."
      # Check if an update is available
      if check_update_needed $package; then
        read -p "An update for $package is available. Update? (y/n): " update_choice
        case "$update_choice" in
        y | Y)
          update_package $package
          ;;
        *)
          echo "Skipping $package update."
          ;;
        esac
      else
        echo "$package is already up to date."
      fi
    fi
    return
  fi

  # Standard check for other packages
  if ! command -v $package &>/dev/null; then
    # Package not installed
    read -p "Install $package? (y/n): " choice
    case "$choice" in
    y | Y)
      install_package $package
      ;;
    *)
      echo "Skipping $package installation."
      ;;
    esac
  else
    echo "$package is already installed."
    # Check if an update is available
    if check_update_needed $package; then
      read -p "An update for $package is available. Update? (y/n): " update_choice
      case "$update_choice" in
      y | Y)
        update_package $package
        ;;
      *)
        echo "Skipping $package update."
        ;;
      esac
    else
      echo "$package is already up to date."
    fi
    # If the package is kitty, ask about config regardless of update status
    if [ "$package" = "kitty" ]; then
      read -p "Do you want to update the kitty config file? (y/n): " config_choice
      case "$config_choice" in
      y | Y)
        install_kitty_config
        ;;
      *)
        echo "Keeping existing kitty configuration."
        ;;
      esac
    fi
  fi
}
# Function to generate installation summary
generate_summary() {
  echo "Summary of optional package installations:"
  echo "----------------------------------------"

  # Check kitty
  if command -v kitty &>/dev/null; then
    echo "✓ kitty: Installed"
  else
    echo "✗ kitty: Not installed"
  fi

  # Check fzf
  if command -v fzf &>/dev/null; then
    echo "✓ fzf: Installed"
  else
    echo "✗ fzf: Not installed"
  fi

  # Check ripgrep
  if command -v rg &>/dev/null; then
    echo "✓ ripgrep: Installed"
  else
    echo "✗ ripgrep: Not installed"
  fi

  # Check fd-find
  if command -v fd &>/dev/null || command -v fdfind &>/dev/null; then
    echo "✓ fd-find: Installed"
  else
    echo "✗ fd-find: Not installed"
  fi

  # Check curl
  if command -v curl &>/dev/null; then
    echo "✓ curl: Installed"
  else
    echo "✗ curl: Not installed"
  fi

  # Check xclip
  if dpkg -l | grep -q "^ii.*xclip"; then
    echo "✓ xclip: Installed"
  else
    echo "✗ xclip: Not installed"
  fi
}

# Header
echo "===== Neovim Environment Setup Script ====="
echo "This script will help you install the necessary tools for Neovim."
echo

# Update package list once at the beginning
echo "Updating package lists to check for available updates..."
sudo apt-get update

# Process each package in our list
for package in "${PACKAGES[@]}"; do
  check_install "$package"
  echo
done

# Generate installation summary
generate_summary

echo "Installation process completed."
