create_symlink() {
  local target="$1"
  local destination="$2"

  if [ ! -e "$target" ]; then
    echo "Error: Target '$target' does not exist."
    return 1
  fi

  if [ -e "$destination" ] && [ ! -L "$destination" ]; then
    local backup="$destination.backup_$(date +"%Y%m%d%H%M%S")"
    echo "Backing up existing file at '$destination' to '$backup'"
    mv "$destination" "$backup"
  elif [ -L "$destination" ]; then
    # Correct existing link to the target
    echo "Correcting existing symlink at '$destination'"
    rm "$destination"
  fi

  # Create the symlink
  ln -s "$target" "$destination"
  echo "Symlink created: '$destination' -> '$target'"
}
