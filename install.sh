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

# If whiptail is not available, install it
if ! command -v whiptail &> /dev/null; then
    echo "Whiptail not found. Attempting to install it..."
    sudo apt-get install -y whiptail || { echo "Failed to install whiptail. Exiting..."; exit 1; }
fi

# Get the URL
if [ $yes = 0 ]; then
    url=$(whiptail --inputbox "Enter the URL of the dotfiles repository" 8 78 "$url" --title "Dotfiles Installation" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "User cancelled the operation."
        exit 1
    fi
fi

# Clone the repository
git clone "$url" ~/dotfiles_temp || { whiptail --msgbox "Failed to clone repository" 8 78; exit 1; }

# Change directory to the cloned repository
cd ~/dotfiles_temp

# Copy dotfiles to the home directory
for item in .* *; do
  if [ "$item" != '.' ] && [ "$item" != '..' ] && [ "$item" != '.git' ]; then
    # Confirm before replacing existing files
    if [ -e ~/"$item" ]; then
      if [ $yes = 1 ] || (whiptail --yesno "Are you sure you want to replace ~/$item?" 8 78); then
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

# Check if the current shell is Fish
if [ $SHELL = '/usr/bin/fish' || $SHELL = '/home/linuxbrew/.linuxbrew/bin/fish' ]; then
  if [ $yes = 1 ] || (whiptail --yesno "You are using Fish shell. Would you like to install optional tools?" 8 78); then
    install_fisher
  fi
fi

if [ $yes = 1 ] || (whiptail --yesno "Would you like to install Neovim and Packer?" 8 78); then
    install_nvim
fi

whiptail --msgbox "Dotfiles have been installed successfully!" 8 78
