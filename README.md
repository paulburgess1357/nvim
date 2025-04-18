# Neovim

This repository contains a collection of scripts to help you set up Neovim along with necessary dependencies and fonts. This is based on [LazyVim](https://github.com/LazyVim/LazyVim).

## Overview

These scripts will help you install and configure both required and optional components:

### Required Components

- **[Neovim](https://neovim.io/)** - Latest version from GitHub (choice of stable or pre-release)
- **[Nerd Fonts](https://www.nerdfonts.com/)** - JetBrainsMono and Mononoki will be installed for proper icons display (Other nerd fonts are fine)
- **[GCC](https://gcc.gnu.org/)** - Required for compiling some Neovim plugins

### Optional Components

- **Terminal Utilities**:

  - **[kitty](https://sw.kovidgoyal.net/kitty/)** - GPU-accelerated terminal emulator
  - **[fzf](https://github.com/junegunn/fzf)** - Command-line fuzzy finder
  - **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Fast text search tool (faster grep alternative)
  - **[fd-find](https://github.com/sharkdp/fd)** - Simple and fast alternative to the `find` command
  - **[curl](https://curl.se/)** - Tool for transferring data from or to a server
  - **[xclip](https://github.com/astrand/xclip)** - Command line interface to X selections (clipboard)

- **Mason Dependencies**:
  - **Python and pip** - Required for Python-based language servers and tools
  - **Node.js and npm** - Required for JavaScript/TypeScript language servers
  - **Cargo/Rust** - Required for some Rust-based tools
  - Other development tools and libraries needed by LSP servers

## Getting Started

### Installation

1. Clone this repository:

```bash
git clone git@github.com:paulburgess1357/Neovim.git
cd Neovim/install_scripts
```

2. Make the master installation script executable:

```bash
chmod +x install_all.sh
```

3. Run the installation script:

```bash
./install_all.sh
```

4. Follow the prompts:
   - The script will check for GCC and install it if needed
   - If Neovim is already installed, you'll be given options to uninstall it, install a new version, or keep the current installation
   - For Neovim, you can choose between stable release or pre-release versions
   - For Nerd Fonts, both JetBrainsMono and Mononoki will be installed
   - For optional packages, you can choose which ones to install
   - Mason dependencies will be installed to ensure LSP servers work correctly
   - You can optionally install the included Neovim configuration

### Individual Installation

If you prefer to install components separately:

- To install only Neovim:

```bash
chmod +x install_neovim.sh
./install_neovim.sh
```

- To install only Nerd Fonts:

```bash
chmod +x install_nerdfonts.sh
./install_nerdfonts.sh
```

- To install optional packages:

```bash
chmod +x install_optional_packages.sh
./install_optional_packages.sh
```

- To install Mason dependencies:

```bash
chmod +x install_mason_dependencies.sh
./install_mason_dependencies.sh
```

- To copy Neovim configuration files:

```bash
chmod +x copy_neovim_into_config.sh
./copy_neovim_into_config.sh
```

### Uninstallation

To remove Neovim:

```bash
chmod +x uninstall_neovim.sh
./uninstall_neovim.sh
```

## Post-Installation

After installation:

1. Set your terminal font to one of the installed Nerd Fonts:

   - "JetBrainsMono Nerd Font"
   - "Mononoki Nerd Font"

2. Start Neovim:

```bash
nvim
```

3. First Startup Steps:

   - When you first start Neovim, Lazy package manager will automatically begin installing plugins
   - Wait for the initial plugin installation to complete
   - Run `:Lazy` to open the Lazy package manager interface
   - Select "Install", "Update", and "Sync" options to ensure all packages are properly installed
   - Then run `:LazyHealth` to check package health and verify that everything is working correctly
     - Note: It's normal to see some warnings in the health check as not all components may be installed or required for your setup
   - Mason should automatically begin installing LSP servers and tools

4. [LazyVim](https://github.com/LazyVim/LazyVim) will manage your plugins and configuration

## Mason Package Installation

The configuration includes a list of Mason packages that will be automatically installed:

### LSP Servers

- ansible-language-server
- bash-language-server
- clangd
- cmake-language-server
- docker-compose-language-service
- dockerfile-language-server
- lua-language-server
- marksman
- neocmakelsp
- pyright
- rust-analyzer
- taplo
- yaml-language-server

### Formatters

- clang-format
- cmakelang
- prettier
- shfmt
- stylua

### Linters

- ansible-lint
- cmakelint
- cpplint
- hadolint
- markdownlint-cli2
- pylint
- ruff
- shellcheck
- sqlfluff

### Debuggers

- codelldb
- debugpy

### Other Tools

- markdown-toc

## LSP Setup

### C++ Project Setup

For C++ projects, you need a `compile_commands.json` file for proper LSP functionality. Here's how to set it up:

1. Create a build folder and run CMake with export option:

```bash
mkdir -p build
cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
```

2. Create a symlink to the compile_commands.json file in your project root:

```bash
cd ..
ln -s ./build/compile_commands.json .
```

This will ensure your C++ language server can properly analyze your code with the correct compiler flags.

## License

See [LICENSE](https://github.com/paulburgess1357/Neovim/blob/main/LICENSE)
