#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PREFIX:-}" ]]; then
    echo "Error: PREFIX must be set"
    exit 1
fi

file "$PREFIX/bin/tmux"

if [[ "$(uname)" == "Darwin" ]]; then
    otool -L "$PREFIX/bin/tmux"
else
    ldd "$PREFIX/bin/tmux" || true
fi

echo "Starting a test tmux session..."
if [[ "$(uname)" == "Darwin" ]]; then
    if ! "$PREFIX/bin/tmux" new-session -d -s test; then
        echo "tmux crashed, retrying under lldb to capture a backtrace..."
        lldb -b \
            -o "settings set target.process.follow-fork-mode child" \
            -o "process launch -- new-session -d -s test" \
            -o "thread backtrace all" \
            -o "quit" \
            -- "$PREFIX/bin/tmux" || true
        exit 1
    fi
else
    "$PREFIX/bin/tmux" new-session -d -s test
fi

echo "Listing tmux sessions..."
"$PREFIX/bin/tmux" ls

echo "Killing test tmux session..."
"$PREFIX/bin/tmux" kill-session -t test
