# History file settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Create history file directory if it doesn't exist
mkdir -p "$(dirname "$HISTFILE")"

# History options
setopt HIST_FCNTL_LOCK           # Use fcntl locking for history file
setopt HIST_IGNORE_DUPS          # Don't record duplicate consecutive commands
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt SHARE_HISTORY             # Share history between sessions
setopt APPEND_HISTORY            # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY        # Write commands to history immediately
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from history
setopt HIST_VERIFY               # Show command with history expansion to user before running it

# Unset options we don't want
unsetopt HIST_IGNORE_ALL_DUPS    # Allow some duplicate commands
unsetopt HIST_SAVE_NO_DUPS       # Save all commands
unsetopt HIST_FIND_NO_DUPS       # Allow finding duplicates in search
unsetopt HIST_EXPIRE_DUPS_FIRST  # Don't expire duplicates first
unsetopt EXTENDED_HISTORY        # Don't save timestamps with commands
