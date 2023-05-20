#!/bin/bash

# Default URL
URL="https://github.com/PunGrumpy/dotfiles.git"

# Function to link dotfiles
function install_dotfiles() {
  echo "📩 Installing dotfiles..."
  
  # Clone the repository
  git clone "$URL" ~/dotfiles_temp || { echo "Failed to clone repository"; exit 1; }

  # Change directory to the cloned repository
  cd ~/dotfiles_temp

  # Copy dotfiles to the home directory
  for item in .* *; do
    if [ "$item" != '.' ] && [ "$item" != '..' ] && [ "$item" != '.git' ]; then
      # Confirm before replacing existing files
      if [ -e ~/"$item" ] && [ "$yes" = "0" ]; then
        echo "Are you sure you want to replace ~/$item? [Y/n]"
        read -r response
        if [[ "$response" =~ ^(yes|y)$ ]]; then
          # Copy the file or directory
          cp -r "$item" ~/
        fi
      else
        cp -r "$item" ~/
      fi
    fi
  done

  # Remove the temporary directory
  cd ~
  rm -rf ~/dotfiles_temp

  echo "✔️ Dotfiles have been installed successfully!"
}

# Function to update all packages (for Debian-based distributions)
function update_packages() {
  echo "📩 Updating all packages..."
  sudo apt update -y || { echo "❌ Failed to update all packages. Exiting..."; exit 1; }
  echo "✔️ All packages have been updated successfully!"
}

# Function to install optional build tools (for Debian-based distributions)
function install_buildtool() {
  echo "📩 Installing build-essential..."
  sudo apt-get -qq install build-essential || { echo "❌ Failed to install build-essential. Exiting..."; exit 1; }
  sudo apt-get -qq install procps || { echo "❌ Failed to install procps. Exiting..."; exit 1; }
  sudo apt-get -qq install curl || { echo "❌ Failed to install curl. Exiting..."; exit 1; }
  sudo apt-get -qq install file || { echo "❌ Failed to install file. Exiting..."; exit 1; }
  sudo apt-get -qq install git || { echo "❌ Failed to install git. Exiting..."; exit 1; }
  echo "✔️ Installed build tools successfully!"
}

# Function to install Homebrew (for macOS and Linux)
function install_homebrew() {
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "❌ Failed to install Homebrew. Exiting..."; exit 1; }
  echo "✔️ Homebrew has been installed successfully!"
}

# Function to configure Homebrew (for Linux)
function set_homebrew_linux_path() {
  echo "⚙️ Configuring Homebrew..."
  (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/runner/.bash_profile || { echo "❌ Failed to configure Homebrew. Exiting..."; exit 1; }
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || { echo "❌ Failed to configure Homebrew. Exiting..."; exit 1; }
  echo "✔️ Homebrew has been configured successfully!"
}

# Function to configure Homebrew (for macOS)
function set_homebrew_macos_path() {
  echo "⚙️ Configuring Homebrew..."
  echo 'PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile || { echo "❌ Failed to configure Homebrew. Exiting..."; exit 1; }
  echo "✔️ Homebrew has been configured successfully!"
}

# Function to install optional tools for Homebrew
function install_homebrew_tools() {
  echo "📩 Installing optional tools for Homebrew..."
  brew install fish || { echo "❌ Failed to install fish. Exiting..."; exit 1; }
  brew install tmux || { echo "❌ Failed to install tmux. Exiting..."; exit 1; }
  brew install gcc || { echo "❌ Failed to install gcc. Exiting..."; exit 1; }
  brew install neovim || { echo "❌ Failed to install neovim. Exiting..."; exit 1; }
  brew install exa || { echo "❌ Failed to install exa. Exiting..."; exit 1; }
  brew install peco || { echo "❌ Failed to install peco. Exiting..."; exit 1; }
  brew install ghq || { echo "❌ Failed to install ghq. Exiting..."; exit 1; }
  brew install node || { echo "❌ Failed to install node. Exiting..."; exit 1; }
  echo "✔️ Optional tools for Homebrew have been installed successfully!"
}

# Function to setting default shell to Fish
function set_shell_default() {
  echo "⚙️ Setting default shell to Fish..."
  if ! command -v fish &> /dev/null; then
    echo "❌ Fish is not installed. Exiting..."
    exit 1
  fi
  if ! grep -q "$(command -v fish)" /etc/shells; then
    sudo sh -c "echo $(command -v fish) >> /etc/shells" || { echo "❌ Failed to add Fish to /etc/shells. Exiting..."; exit 1; }
  fi
  echo "$USER" | sudo -S chsh -s "$(command -v fish)" || { echo "❌ Failed to set default shell to Fish. Exiting..."; exit 1; }
  echo "✔️ Default shell has been set to Fish successfully!"
}

# Function to install optional tools for Fish shell
function install_fisher() {
  echo "Installing optional tools for Fish shell..."
  fish -c "
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source;
    fisher install jorgebucaran/fisher || echo '❌ Failed to install fisher. Exiting...' && exit 1;
    fisher install jethrokuan/z || echo '❌ Failed to install z. Exiting...' && exit 1;
    fisher install jethrokuan/fzf || echo '❌ Failed to install fzf. Exiting...' && exit 1;
    fisher install nickeb96/puffer-fish || echo '❌ Failed to install puffer-fish. Exiting...' && exit 1;
    fisher install laughedelic/pisces || echo '❌ Failed to install pisces. Exiting...' && exit 1;
    fisher install ilancosman/tide@v5 || echo '❌ Failed to install tide. Exiting...' && exit 1;
    echo '✔️ Optional tools for Fish shell have been installed successfully!'
  "
}

# Function to install commitizen
function install_commitizen() {
  echo "Installing commitizen..."
  npm install -g commitizen cz-conventional-changelog || { echo "Failed to install commitizen. Exiting..."; exit 1;}
  echo "Commitizen has been installed successfully!"
}

# Function to display help
function display_help() {
    echo "Usage: $0 [options] -u <URL>"
    echo
    echo "This script installs dotfiles from a given GitHub URL."
    echo
    echo "Options:"
    echo "-h, --help            Display this help message."
    echo "-s, --silent          Run the script in silent mode."
    echo "-y, --yes             Automatically answer yes to all prompts."
    echo
    echo "If no URL is provided, the script will use a default URL."
}

# Argument parsing
silent=0
yes=0
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--silent)
            silent=1
            shift
            ;;
        -y|--yes)
            yes=1
            shift
            ;;
        -h|--help)
            display_help
            exit 0
            ;;
        *)
            echo "Invalid argument: $1"
            display_help
            exit 1
            ;;
    esac
done

if [ "$silent" = 1 ]; then
  echo "🤫 Running the script in silent mode..."
fi

if [ "$yes" = 1 ]; then
  echo "🤖 Automatically answering yes to all prompts..."
fi

# Install dotfiles
install_dotfiles

# Check OS
OS=""
case "$(uname -s)" in
   Darwin)
     OS="macOS"
     ;;
   Linux)
     OS="Linux"
     ;;
   *)
     OS="unknown"
     ;;
esac

if [ "$OS" = "Linux" ]; then
  clear
  echo "🐧 Running on Linux..."

  # Update package lists
  if [ "$yes" = 1 ]; then
    update_packages
  else
    echo "🤔 Do you want to update package lists? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      update_packages
    fi
  fi

  # Install build tools
  if [ "$yes" = 1 ]; then
    install_build_tools
  else
    echo "🤔 Do you want to install build tools? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_build_tools
    fi
  fi

  # Install Homebrew
  if [ "$yes" = 1 ]; then
    install_homebrew
  else
    echo "🤔 Do you want to install Homebrew? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_homebrew
    fi
  fi

  # Set path to Homebrew
  if [ "$yes" = 1 ]; then
    set_homebrew_linux_path
  else
    echo "🤔 Do you want to set path to Homebrew? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      set_homebrew_linux_path
    fi
  fi

  # Install optional tools for Homebrew
  if [ "$yes" = 1 ]; then
    install_homebrew_tools
  else
    echo "🤔 Do you want to install optional tools for Homebrew? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_homebrew_tools
    fi
  fi

  # Set default shell to Fish
  if [ "$yes" = 1 ]; then
    set_shell_default
  else
    echo "🤔 Do you want to set default shell to Fish? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      set_shell_default
    fi
  fi

  # Install optional tools for Fish shell
  if [ "$yes" = 1 ]; then
    install_fisher
  else
    echo "🤔 Do you want to install optional tools for Fish shell? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_fisher
    fi
  fi

  # Install commitizen
  if [ "$yes" = 1 ]; then
    install_commitizen
  else
    echo "🤔 Do you want to install commitizen? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_commitizen
    fi
  fi
elif [ "$OS" = "macOS" ]; then
  clear
  echo "🍎 Running on macOS..."

  # Install Homebrew
  if [ "$yes" = 1 ]; then
    install_homebrew
  else
    echo "🤔 Do you want to install Homebrew? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_homebrew
    fi
  fi

  # Set path to Homebrew
  if [ "$yes" = 1 ]; then
    set_homebrew_macos_path
  else
    echo "🤔 Do you want to set path to Homebrew? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      set_homebrew_macos_path
    fi
  fi

  # Install optional tools for Homebrew
  if [ "$yes" = 1 ]; then
    install_homebrew_tools
  else
    echo "🤔 Do you want to install optional tools for Homebrew? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_homebrew_tools
    fi
  fi

  # Set default shell to Fish
  if [ "$yes" = 1 ]; then
    set_shell_default
  else
    echo "🤔 Do you want to set default shell to Fish? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      set_shell_default
    fi
  fi

  # Install optional tools for Fish shell
  if [ "$yes" = 1 ]; then
    install_fisher
  else
    echo "🤔 Do you want to install optional tools for Fish shell? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_fisher
    fi
  fi

  # Install commitizen
  if [ "$yes" = 1 ]; then
    install_commitizen
  else
    echo "🤔 Do you want to install commitizen? [y/N]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_commitizen
    fi
  fi
else
  echo "❌ Unsupported OS. Exiting..."
  exit 1
fi
  

echo "🎉 Installation completed successfully!"
