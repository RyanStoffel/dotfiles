#!/usr/bin/env bash

# tmux project session switcher
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

  # Fallback to fzf search pre-filtered by argument
  if [ -z "$SELECTED" ]; then
    SELECTED=$(list_projects | fzf -q "$QUERY" -1 -0)
  fi
else
  # Interactive selection via fzf
  SELECTED=$(list_projects | fzf --prompt="Select Project > " --height=40% --reverse)
fi

if [ -z "$SELECTED" ]; then
  exit 0
fi

# Trim trailing slash if present
SELECTED="${SELECTED%/}"

PROJECT_DIR="$DEV_DIR/$SELECTED"
# Convert session name (e.g. personal/caffeine -> personal-caffeine)
SESSION_NAME=$(echo "$SELECTED" | tr '/.' '-')

# Create session if it doesn't exist
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"
fi

# Attach or switch to session
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$SESSION_NAME"
elif [ -t 1 ]; then
  tmux attach-session -t "$SESSION_NAME"
fi
