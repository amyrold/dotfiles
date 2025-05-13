#!/bin/zsh

DOTFILES="$(pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# Create backup directory
mkdir -p $BACKUP_DIR

# Function to backup and symlink files
setup_symlink() {
  local src=$1     # Source file without dot
  local dest=$2    # Destination file with dot
  
  # Backup existing file if it exists
  if [[ -f "$dest" ]] || [[ -d "$dest" ]]; then
    echo "Backing up $dest to $BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
  fi
  
  # Create symlink
  echo "Creating symlink: $dest -> $src"
  ln -sf "$src" "$dest"
}

# Bash (if you use it)
# setup_symlink "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
# setup_symlink "$DOTFILES/bash/bash_profile" "$HOME/.bash_profile"

# Zsh
setup_symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

# Vim
setup_symlink "$DOTFILES/vim/vimrc" "$HOME/.vimrc"

# Git
setup_symlink "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

# Add more symlinks for other config files

echo "Dotfiles installation complete!"
