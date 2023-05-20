#!/bin/bash

# Default URL
url="https://github.com/PunGrumpy/dotfiles.git"

# Function to install Neovim and Packer
function install_nvim() {
    echo "Installing Neovim and Packer..."
    sudo apt-get install -y neovim || { echo "Failed to install Neovim. Exiting..."; exit 1; }
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim || { echo "Failed to install Packer. Exiting..."; exit 1; }
    echo "Neovim and Packer have been installed successfully!"
}

function install_fisher() {
  echo "Installing optional tools for Fish shell..."
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  fisher install jethrokuan/z || { echo "Failed to install z. Exiting..."; exit 1;}
  fisher install jethrokuan/fzf || { echo "Failed to install fzf. Exiting..."; exit 1;}
  fisher install fisher install nickeb96/puffer-fish || { echo "Failed to install puffer-fish. Exiting..."; exit 1;}
  fisher install laughedelic/pisces || { echo "Failed to install pisces. Exiting..."; exit 1;}
  fisher install ilancosman/tide@v5 || { echo "Failed to install tide. Exiting..."; exit 1;}
  echo "Optional tools for Fish shell have been installed successfully!"
}

function install_brew() {
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Failed to install Homebrew. Exiting..."; exit 1; }
  echo "Homebrew has been installed successfully!"
}

function install_commitizen() {
  echo "Installing commitizen..."
  npm install -g commitizen cz-conventional-changelog || { echo "Failed to install commitizen. Exiting..."; exit 1; }
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
    echo "-u, --url <URL>       Specify the URL of the dotfiles repository."
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
        -u|--url)
            url="$2"
            shift
            shift
            ;;
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

# Clone the repository
git clone "$url" ~/dotfiles_temp || { echo "Failed to clone repository"; exit 1; }

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

if [[ $SHELL = '/usr/bin/fish' || $SHELL = '/home/linuxbrew/.linuxbrew/bin/fish' ]]; then
  if [ "$yes" = "1" ]; then
    install_fisher
  else
    echo "You are using Fish shell. Would you like to install optional tools? [Y/n]"
    read -r response
    if [[ "$response" =~ ^(yes|y)$ ]]; then
      install_fisher
    fi
  fi
fi

if [ "$yes" = "1" ]; then
  install_brew
else
  echo "Would you like to install Homebrew? [Y/n]"
  read -r response
  if [[ "$response" =~ ^(yes|y)$ ]]; then
    install_brew
  fi
fi

if [ "$yes" = "1" ]; then
  install_commitizen
else
  echo "Would you like to install commitizen? [Y/n]"
  read -r response
  if [[ "$response" =~ ^(yes|y)$ ]]; then
    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
      echo "npm is not installed. Exiting..."
      echo "Would you like to install npm by Homebrew? [Y/n]"
      read -r response
      if [[ "$response" =~ ^(yes|y)$ ]]; then
        echo "Installing npm..."
        brew install npm || { echo "Failed to install npm. Exiting..."; exit 1; }
        echo "npm has been installed successfully!"
      fi

      echo "Would you like to install npm by apt? [Y/n]"
      read -r response
      if [[ "$response" =~ ^(yes|y)$ ]]; then
        echo "Installing npm..."
        sudo apt-get install -y npm || { echo "Failed to install npm. Exiting..."; exit 1; }
        echo "npm has been installed successfully!"
      fi
      
      echo "You can install npm by yourself and run this script again."
      exit 1
    fi

    install_commitizen
  fi
fi

if [ "$yes" = "1" ]; then
  install_nvim
else
  echo "Would you like to install Neovim and Packer? [Y/n]"
  read -r response
  if [[ "$response" =~ ^(yes|y)$ ]]; then
    install_nvim
  fi
fi

echo "Dotfiles have been installed successfully!"
