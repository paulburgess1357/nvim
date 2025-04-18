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

echo "===== JetBrainsMono and Mononoki Nerd Fonts Installer ====="
echo "This script will download and install JetBrainsMono and Mononoki Nerd Fonts."
echo

# Check for required tools
for cmd in curl unzip; do
  if ! command -v $cmd &>/dev/null; then
    read -p "$cmd is required but not installed. Install it now? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      sudo apt install -y $cmd
    else
      error "$cmd is required to continue."
    fi
  fi
done

# Define the font directory
SYSTEM_FONTS_DIR="$HOME/.local/share/fonts"
TEMP_DIR=$(mktemp -d)

# Create fonts directory if it doesn't exist
mkdir -p "$SYSTEM_FONTS_DIR"

# Define fonts to install
FONTS=("JetBrainsMono" "Mononoki")

# Ask for confirmation
echo "This script will install the following Nerd Fonts:"
for font in "${FONTS[@]}"; do
  echo "- $font"
done
read -p "Continue with installation? (y/n): " choice
if [[ ! "$choice" =~ ^[Yy]$ ]]; then
  echo "Installation aborted."
  exit 0
fi

# Get the latest release URL
echo "Detecting latest Nerd Fonts release..."
RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest"
REDIRECT_URL=$(curl -Ls -o /dev/null -w %{url_effective} $RELEASE_URL)
VERSION=${REDIRECT_URL##*/}
echo "Found version: $VERSION"

# Download and install selected fonts
for font_name in "${FONTS[@]}"; do
  echo "Downloading $font_name Nerd Font..."

  # Construct the download URL
  DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/$font_name.zip"

  echo "Download URL: $DOWNLOAD_URL"

  # Download the font
  if ! curl -L --progress-bar "$DOWNLOAD_URL" -o "$TEMP_DIR/$font_name.zip"; then
    echo "Failed to download $font_name. Skipping..."
    continue
  fi

  echo "Installing $font_name Nerd Font..."

  # Create a directory for the font
  FONT_DIR="$TEMP_DIR/$font_name"
  mkdir -p "$FONT_DIR"

  # Extract the font
  unzip -q "$TEMP_DIR/$font_name.zip" -d "$FONT_DIR" || {
    echo "Failed to extract $font_name.zip. Skipping..."
    continue
  }

  # Copy font files to the system fonts directory
  find "$FONT_DIR" -name "*.ttf" -o -name "*.otf" | while read font_file; do
    cp "$font_file" "$SYSTEM_FONTS_DIR/"
  done

  success "$font_name Nerd Font installed successfully."
done

# Clean up
rm -rf "$TEMP_DIR"

# Update font cache
echo "Updating font cache..."
fc-cache -f

success "Font installation complete!"
echo "You may need to restart your applications to use the new fonts."
echo "To verify installation, run: fc-list | grep -i nerd"
echo
echo -e "\e[1;33mIMPORTANT: Don't forget to set your terminal font to one of the installed Nerd Fonts (JetBrainsMono Nerd Font or Mononoki Nerd Font) for proper icon display!\e[0m"
