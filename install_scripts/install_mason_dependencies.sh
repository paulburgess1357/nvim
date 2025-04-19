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

# Function to display info messages
info() {
  echo -e "\e[34m$1\e[0m"
}

echo "===== Installing Mason Dependencies ====="
echo "This script will install dependencies required by Mason for Neovim"
echo

# Update package lists
echo "Updating package lists..."
sudo apt update

# List of dependencies to install
DEPENDENCIES=(
  "python3"
  "python3-pip"
  "python3-venv"
  "npm"
  "nodejs"
  "cargo"
  "unzip"
  "wget"
  "git"
)

# Install dependencies
for dep in "${DEPENDENCIES[@]}"; do
  info "Checking $dep..."
  if ! dpkg -l | grep -q "^ii.*$dep"; then
    read -p "Install $dep? (y/n): " choice
    case "$choice" in
    y | Y)
      echo "Installing $dep..."
      sudo apt install -y $dep
      if [ $? -ne 0 ]; then
        error "Failed to install $dep. Aborting."
      fi
      success "$dep installed successfully."
      ;;
    *)
      echo "Skipping $dep installation."
      ;;
    esac
  else
    echo "$dep is already installed."
  fi
done

# Ensure pip is up to date
info "Updating pip..."
python3 -m pip install --upgrade pip

# Install Python packages commonly needed by LSP servers
info "Installing common Python packages needed by LSP servers..."
python3 -m pip install --user pynvim pylint autopep8 flake8 yapf black pyright ruff

# Check if npm is installed and install global packages
if command -v npm &>/dev/null; then
  info "Installing common npm packages needed by LSP servers..."
  sudo npm install -g neovim prettier typescript typescript-language-server bash-language-server vscode-langservers-extracted yaml-language-server markdownlint-cli
fi

# Check if cargo is installed
if command -v cargo &>/dev/null; then
  info "Rust is installed. You can install Rust-based tools with cargo if needed."
else
  info "Rust was not detected. Some Mason packages may require Rust/Cargo."
fi

# Generate summary
echo
echo "Summary of Mason dependencies:"
echo "-----------------------------"
echo "✓ Python: $(python3 --version 2>&1)"
echo "✓ Pip: $(pip3 --version 2>&1)"

if command -v npm &>/dev/null; then
  echo "✓ Node.js: $(node --version 2>&1)"
  echo "✓ npm: $(npm --version 2>&1)"
else
  echo "✗ Node.js/npm: Not installed"
fi

if command -v cargo &>/dev/null; then
  echo "✓ Rust/Cargo: $(cargo --version 2>&1)"
else
  echo "✗ Rust/Cargo: Not installed"
fi

if command -v git &>/dev/null; then
  echo "✓ Git: $(git --version 2>&1)"
else
  echo "✗ Git: Not installed"
fi

success "Mason dependencies installation completed."
echo
echo "You should now be able to install Mason packages in Neovim without dependency issues."
