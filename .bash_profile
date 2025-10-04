if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists (for tmux)
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
