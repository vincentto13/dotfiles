#!/bin/zsh

update_my_env() {
  # Prevent recursive calls when sourcing .zshrc
  [[ -n "$_UPDATE_MY_ENV_RUNNING" ]] && return 0
  _UPDATE_MY_ENV_RUNNING=1

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

  cd - > /dev/null
  unset _UPDATE_MY_ENV_RUNNING
}

# Undo terminal modes a dead remote session may have left enabled
# (mouse tracking, bracketed paste, focus events) without clearing
# the screen, so scrollback of a broken session stays copyable.
fix-term() {
  # DECSTR soft reset: scroll region, origin/insert/app-cursor modes,
  # autowrap, charset - everything a dead remote app can leave behind,
  # without touching screen contents or scrollback (unlike 'reset')
  printf '\e[!p'
  # belt and braces for terminals with partial DECSTR support:
  # ASCII charset, no scroll region, replace mode, normal keypad
  printf '\e(B\e[r\e[4l\e>'
  # leave a stuck alternate screen (returns to normal scrollback)
  printf '\e[?1049l'
  # mouse tracking, bracketed paste and focus reporting off; cursor on
  printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?1015l\e[?2004l\e[?1004l\e[?25h'
  stty sane
}

# A dropped ssh connection never lets the remote apps send their
# "mouse off" sequences, so clean up as soon as ssh exits.
ssh() {
  command ssh "$@"
  local rc=$?
  fix-term
  return $rc
}

