#!/bin/zsh

DOTFILES="$(pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup"

# Find the most recent backup
LATEST_BACKUP=$(find "$BACKUP_DIR" -maxdepth 1 -type d | sort -r | head -n 1)

if [[ -z "$LATEST_BACKUP" ]]; then
  echo "No backup directory found. Nothing to restore."
  exit 1
fi

echo "Using backup from: $LATEST_BACKUP"

# Function to remove symlink and restore backup
restore_from_backup() {
  local dest=$1
  local backup_file="$LATEST_BACKUP/$(basename "$dest")"
  
  # Check if the current file is a symlink
  if [[ -L "$dest" ]]; then
    echo "Removing symlink: $dest"
    
    # Check if it points to our dotfiles repo
    link_target=$(readlink "$dest")
    if [[ "$link_target" == "$DOTFILES"* ]]; then
      rm "$dest"
      
      # Restore from backup if it exists
      if [[ -f "$backup_file" ]] || [[ -d "$backup_file" ]]; then
        echo "Restoring from backup: $backup_file -> $dest"
        cp -R "$backup_file" "$dest"
      fi
    else
      echo "$dest is a symlink but doesn't point to your dotfiles repo. Skipping."
    fi
  else
    echo "$dest is not a symlink. Skipping."
  fi
}

# Ask for confirmation
echo "This will remove symlinks from your dotfiles and restore original configurations."
read -q "REPLY?Continue? (y/n) "
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Uninstall cancelled."
  exit 1
fi

# Restore configurations - match these with what you have in install.sh
# restore_from_backup "$HOME/.bashrc"
# restore_from_backup "$HOME/.bash_profile"
restore_from_backup "$HOME/.zshrc"
restore_from_backup "$HOME/.vimrc"
restore_from_backup "$HOME/.gitconfig"

# Add more files to restore as needed - must match what's in install.sh

echo "Uninstall complete! Original configurations have been restored."
