#!/usr/bin/env bash

# tmux dev workspace. Run as `tdev` from any shell, including inside tmux.
#
# ---------------------------------------------------
# |                    |             AI             |
# |                    |           (omp)            |
# |  Main Terminal     |----------------------------|
# |  (Dev Work)        | Dev Laptop   |     VM      |
# |                    | (ssh dev)    |  (ssh vm)   |
# ---------------------------------------------------

set -euo pipefail

SESSION_NAME="dev"

attach() {
  if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$SESSION_NAME"
  elif [ -t 1 ]; then
    tmux attach-session -t "$SESSION_NAME"
  fi
}

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  attach
  exit 0
fi

# Panes are addressed by pane id (%N) rather than index, so the layout does not
# depend on base-index or pane-base-index.
main=$(tmux new-session -d -s "$SESSION_NAME" -n workspace -P -F '#{pane_id}')
ai=$(tmux split-window -h -t "$main" -l 45% -P -F '#{pane_id}')
dev=$(tmux split-window -v -t "$ai" -l 40% -P -F '#{pane_id}')
vm=$(tmux split-window -h -t "$dev" -l 50% -P -F '#{pane_id}')

tmux send-keys -t "$ai" "omp" C-m
tmux send-keys -t "$dev" "ssh dev" C-m
tmux send-keys -t "$vm" "sshvm" C-m

tmux select-pane -t "$main"

attach
