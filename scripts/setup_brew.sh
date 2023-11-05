# Check if the system is macOS and install Homebrew
if [ "$(uname)" == "Darwin" ]; then
  echo "Detected macOS"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi
