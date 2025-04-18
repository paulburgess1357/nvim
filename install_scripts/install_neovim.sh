#!/bin/bash
# Function to display error messages
error() {
  echo -e "\e[31mERROR: $1\e[0m" >&2
  exit 1
}
echo "===== Neovim GitHub Release Installer (Tarball) ====="
echo "This script will download and install Neovim from GitHub using the tarball method."
echo

# Check if curl is installed
if ! command -v curl &>/dev/null; then
  read -p "curl is required but not installed. Install it now? (y/n): " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    sudo apt install -y curl
  else
    error "curl is required to continue."
  fi
fi

# Check if Neovim is already installed
if command -v nvim &>/dev/null; then
  CURRENT_VERSION=$(nvim --version | head -n 1)
  echo "Neovim is currently installed: $CURRENT_VERSION"
fi

# Ask if user wants stable release, pre-release, or skip installation
echo "Please select which version of Neovim to install:"
echo "1) Stable release (recommended)"
echo "2) Latest pre-release (may be unstable)"
echo "3) Don't install Neovim (keep current installation)"
read -p "Enter your choice (1, 2, or 3): " version_choice
case "$version_choice" in
1)
  RELEASE_TYPE="latest"
  RELEASE_DESC="stable release"
  INSTALL_NEOVIM=true
  ;;
2)
  # Get the newest release including pre-releases
  RELEASE_TYPE="releases"
  RELEASE_DESC="pre-release"
  INSTALL_NEOVIM=true
  ;;
3)
  echo "Skipping Neovim installation. Using current installation."
  exit 0
  ;;
*)
  echo "Invalid choice. Defaulting to stable release."
  RELEASE_TYPE="latest"
  RELEASE_DESC="stable release"
  INSTALL_NEOVIM=true
  ;;
esac

# Ask for final confirmation
if [ "$INSTALL_NEOVIM" = true ]; then
  read -p "Do you want to install the latest $RELEASE_DESC version of Neovim? (y/n): " choice
  if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 0
  fi

  echo "Fetching Neovim $RELEASE_DESC information..."
  if [ "$RELEASE_TYPE" = "latest" ]; then
    # Get the latest stable release
    GITHUB_API_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
    RELEASE_JSON=$(curl -s "$GITHUB_API_URL") || error "Failed to fetch release information"
  else
    # Get all releases including pre-releases and find the newest one
    GITHUB_API_URL="https://api.github.com/repos/neovim/neovim/releases"
    RELEASE_JSON=$(curl -s "$GITHUB_API_URL" | head -n 1000) || error "Failed to fetch release information"
    # Extract the first (most recent) release
    RELEASE_JSON=$(echo "$RELEASE_JSON" | sed -n '1,/^  }/p')
  fi

  # Extract version
  VERSION=$(echo "$RELEASE_JSON" | grep -o '"tag_name": "[^"]*' | head -1 | sed 's/"tag_name": "//')
  echo "Selected Neovim version: $VERSION"

  # Create a temporary directory
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || error "Failed to create temporary directory"

  echo "Downloading Neovim tarball..."
  TARBALL_URL=$(echo "$RELEASE_JSON" | grep -o '"browser_download_url": "[^"]*nvim-linux-x86_64.tar.gz[^"]*"' | head -1 | sed 's/"browser_download_url": "//' | sed 's/"//')
  if [ -z "$TARBALL_URL" ]; then
    error "Could not find tarball download URL"
  fi

  echo "Download URL: $TARBALL_URL"
  curl -L -o nvim-linux-x86_64.tar.gz "$TARBALL_URL" || error "Failed to download tarball"

  echo "Extracting tarball..."
  tar xzf nvim-linux-x86_64.tar.gz || error "Failed to extract tarball"

  echo "Installing Neovim to /usr/local/..."
  sudo rm -rf /usr/local/share/nvim-linux-x86_64 2>/dev/null
  sudo mkdir -p /usr/local/share
  sudo mv nvim-linux-x86_64 /usr/local/share/ || error "Failed to move extracted files to /usr/local/share"

  echo "Creating symlink in /usr/local/bin..."
  sudo rm -f /usr/local/bin/nvim 2>/dev/null
  sudo mkdir -p /usr/local/bin
  sudo ln -s /usr/local/share/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim || error "Failed to create symlink"

  # Clean up
  cd - >/dev/null
  rm -rf "$TMP_DIR"

  # Verify installation
  if command -v nvim &>/dev/null; then
    INSTALLED_VERSION=$(nvim --version | head -n 1)
    echo "Neovim installed successfully!"
    echo "Version: $INSTALLED_VERSION"
    echo "Installation location: /usr/local/share/nvim-linux-x86_64"
    echo "Executable symlinked to: /usr/local/bin/nvim"
  else
    error "Installation seems to have failed. Please check the logs above."
  fi

  echo "Installation complete."
fi
