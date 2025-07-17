# =============================================================================
# Zsh Options and Shell Behavior
# =============================================================================

# Changing directories
setopt AUTO_CD              # Change to directory without typing cd
setopt AUTO_PUSHD           # Push directories to stack automatically
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories
setopt PUSHD_MINUS          # Use - instead of + for directory stack

# Completion
setopt AUTO_MENU            # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD     # Complete from both ends of a word
setopt ALWAYS_TO_END        # Move cursor to end of word after completion

# Expansion and globbing
setopt EXTENDED_GLOB        # Use extended globbing syntax
setopt GLOB_DOTS            # Include hidden files in globbing
setopt NUMERIC_GLOB_SORT    # Sort globs numerically

# Input/Output
setopt CORRECT              # Try to correct command spelling
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt HASH_CMDS            # Hash commands for faster lookup
setopt HASH_DIRS            # Hash directories for faster lookup

# Job control
setopt AUTO_RESUME          # Resume jobs when referenced
setopt LONG_LIST_JOBS       # List jobs in long format
setopt NOTIFY               # Report job status immediately

# Prompt
setopt PROMPT_SUBST         # Allow parameter expansion in prompt

# Don't beep on errors
unsetopt BEEP
unsetopt HIST_BEEP
unsetopt LIST_BEEP
