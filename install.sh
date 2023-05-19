#!/bin/bash

# Default URL
url="https://github.com/PunGrumpy/dotfiles.git"
silent=false

# Function to display help message
function display_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -h, --help        Display this help message."
    echo "  -u, --url URL     Specify the URL of the dotfiles repository."
    echo "  -s, --silent      Run the script in silent mode, without interactive prompts."
    echo
    echo "This script installs dotfiles from a specified GitHub repository."
    exit 0
}

# Parse command-line arguments
while (( "$#" )); do
  case "$1" in
    -h|--help)
      display_help
      ;;
    -u|--url)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        url=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -s|--silent)
      silent=true
      shift
      ;;
    -*|--*=)
      echo "Error: Unsupported flag $1" >&2
      display_help
      ;;
    *)
      shift
      ;;
  esac
done

# If whiptail is not available, install it
if ! $silent && ! command -v whiptail &> /dev/null; then
    echo "Whiptail not found. Attempting to install it..."
    sudo apt-get install -y whiptail || { echo "Failed to install whiptail. Exiting..."; exit 1; }
fi

# Get the URL if not in silent mode
if ! $silent; then
  url=$(whiptail --inputbox "Enter the URL of the dotfiles repository" 8 78 "$url" --title "Dotfiles Installation" 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus != 0 ]; then
      echo "User cancelled the operation."
      exit 1
  fi
fi

# Clone the repository
git clone "$url" ~/dotfiles_temp || { $silent || whiptail --msgbox "Failed to clone repository" 8 78; exit 1; }

# Change directory to the cloned repository
cd ~/dotfiles_temp

# Copy dotfiles to the home directory
for file in .*; do
  if [ -f "$file" ]; then
    # Confirm before replacing existing files if not in silent mode
    if [ -e ~/"$file" ]; then
      if $silent || (whiptail --yesno "Are you sure you want to replace ~/$file?" 8 78); then
        # Copy the file
        cp "$file" ~/
      fi
    else
      cp "$file" ~/
    fi
  fi
done

# Remove the temporary directory
cd ~
rm -rf ~/dotfiles_temp

# Display success message if not in silent mode
if ! $silent; then
  whiptail --msgbox "Dotfiles have been installed successfully!" 8 78
fi
