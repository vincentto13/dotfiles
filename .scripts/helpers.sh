#!/bin/zsh

update_my_env() {
  # Resolve the symlink to find the original script location
  local script_path
  script_path=$(readlink -f "${(%):-%x}")  # This gets the real path even if symlinked

  # Get the directory that contains helpers.sh (e.g., ~/.dotfiles/.scripts)
  local script_dir
  script_dir=$(dirname "$script_path")

  # Get the root of the git repo (assumes it's inside ~/.dotfiles or similar)
  local git_root
  git_root=$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$git_root" ]]; then
    echo "❌ Not inside a Git repository: $script_dir"
    return 1
  fi

  # Change to git root to check status
  cd "$git_root" || return 1

  # Fetch latest changes
  git fetch

  # Check if we're at the tip of the current branch
  local local_head remote_head
  local_head=$(git rev-parse HEAD)
  remote_head=$(git rev-parse @{u} 2>/dev/null)

  if [[ "$local_head" == "$remote_head" ]]; then
    echo "✅ Already at the latest commit on $(git rev-parse --abbrev-ref HEAD)"
  else
    echo "⬇️ Pulling latest changes..."
    git pull --rebase --autostash || {
      echo "❌ Git pull failed."
      return 1
    }

    stow .

    echo "🔁 Reloading shell environment..."
    source ~/.zshrc
  fi
  
  cd -
}

