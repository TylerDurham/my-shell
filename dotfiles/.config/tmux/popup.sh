#!/usr/bin/env bash

# 👻 put this file into your $PATH, normally `~/.local/bin/toggle-tmux-popup`
# 👻 this script should have runable permission.

CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")

if [[ "$CURRENT_SESSION" == popup_* ]]; then
  tmux detach-client
else
  WINDOW_ID=$(tmux display-message -p "#{window_id}" | tr -d '@')
  POPUP_SESSION="popup_${WINDOW_ID}"
  CWD=$(tmux display-message -p "#{pane_current_path}")
  # if tmux has-session -t "$POPUP_SESSION" 2>/dev/null; then
  # tmux send-keys -t "$POPUP_SESSION" " cd $(printf '%q' "$CWD")" Enter
  # fi
  tmux popup -d "$CWD" -xC -yC -w95% -h95% \
    -b rounded \
    -E "tmux attach -t '$POPUP_SESSION' || tmux new -s '$POPUP_SESSION'" # -s "fg=#cdd6f4,bg=default" \
  # -S "fg=#313244" \
fi
