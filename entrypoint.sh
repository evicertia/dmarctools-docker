#!/bin/sh

# Function to handle termination signals
terminate() {
  echo "Terminating..."
  # Send termination signal to all child processes of this script
  pkill -TERM -P $$
  exit 0
}

# Trap termination signals
trap terminate SIGTERM SIGINT

# Check for the command choice and arguments passed
case "$1" in
  "parsedmarc" | "checkdmarc")
    exec "$@"
    ;;
  "shell")
    # Start an interactive shell
    exec sh
    ;;
  *)
    echo "Usage: $0 {parsedmarc|checkdmarc|shell}"
    exit 1
    ;;
esac
