#!/bin/bash

# Function to install Homebrew on macOS if not already installed
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

# Function to install Git and clone/update the dotfiles repository
install_git_and_clone_dotfiles() {
  # Check if Git is installed
  if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing Git..."
    case "$(uname -s)" in
      Darwin)
        # macOS using Homebrew
        install_homebrew
        brew install git
        ;;
      Linux)
        # Linux using package manager (Debian/Ubuntu, Arch, Alpine, SLES, RedHat)
        if command -v apt &>/dev/null; then
          sudo apt update
          sudo apt install -y git
        elif command -v pacman &>/dev/null; then
          sudo pacman -Syu --noconfirm git
        elif command -v apk &>/dev/null; then
          sudo apk update
          sudo apk add git
        elif command -v zypper &>/dev/null; then
          sudo zypper --non-interactive install git
        elif command -v yum &>/dev/null; then
          sudo yum install -y git
        else
          echo "Unsupported Linux distribution. Please install Git manually."
          exit 1
        fi
        ;;
      *)
        echo "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
    esac
  fi

  # Check if $HOME/.dotfiles exists
  if [ -d "$HOME/.dotfiles" ]; then
    echo "Updating existing dotfiles repository..."
    cd "$HOME/.dotfiles" || exit
    git pull
  else
    # Clone the dotfiles repository using HTTPS into $HOME/.dotfiles
    git clone https://github.com/vincentto13/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles" || exit
  fi

  # Run the setup script
  ./setup_brew.sh
  ./setup_locale.sh
  ./setup_zsh.sh
  ./setup_tmux.sh
  ./setup_nvim.sh
}

# Run the installation function
install_git_and_clone_dotfiles

