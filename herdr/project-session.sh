#!/usr/bin/env bash

# herdr project session switcher
# Scans ~/Developer/personal, ~/Developer/work, and ~/Developer/school for projects.

DEV_DIR="$HOME/Developer"
GROUPS=("personal" "work" "school")

# Function to list all project subdirectories under group folders
list_projects() {
  fd --max-depth 1 --type d . "$DEV_DIR/personal" "$DEV_DIR/work" "$DEV_DIR/school" 2>/dev/null | sed "s|^$DEV_DIR/||" | sed 's|/$||'
}

SELECTED=""

# If a project argument is provided
if [ -n "$1" ]; then
  QUERY="$1"
  for group in "${GROUPS[@]}"; do
    if [ -d "$DEV_DIR/$QUERY" ]; then
      SELECTED="$QUERY"
      break
    elif [ -d "$DEV_DIR/$group/$QUERY" ]; then
      SELECTED="$group/$QUERY"
      break
    fi
  done

  # Fallback to fzf pre-filtered search
  if [ -z "$SELECTED" ]; then
    SELECTED=$(list_projects | fzf -i -q "$QUERY" -1 -0)
  fi
else
  # Interactive fzf selection
  SELECTED=$(list_projects | fzf --prompt="Select Herdr Project > " --height=40% --reverse)
fi

if [ -z "$SELECTED" ]; then
  exit 0
fi

SELECTED="${SELECTED%/}"
PROJECT_DIR="$DEV_DIR/$SELECTED"
# Format session name (e.g. personal/caffeine -> personal-caffeine)
SESSION_NAME=$(echo "$SELECTED" | tr '/.' '-' | tr '[:upper:]' '[:lower:]')

# Open or attach Herdr session inside project directory
cd "$PROJECT_DIR" && exec herdr --session "$SESSION_NAME"
