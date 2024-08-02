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

# Function to run parsedmarc and check exit status
run_parsedmarc() {
  echo "server mode"
  # Execute the parsedmarc command with the modified arguments
  $COMMAND
  # Capture the exit status of the command
  local status=$?
  if [ $status -ne 0 ]; then
    echo "Error: parsedmarc command exited with status $status. Exiting..."
    exit 1  # Exit the script upon encountering an error
  else
    echo "parsedmarc command executed successfully"
  fi
}

# Check for the command choice and arguments passed
case "$1" in
  "parsedmarc" | "checkdmarc")
    # Check if the arguments contain '--server'
    if echo "$@" | grep -q -- "--server"; then
      # Start the health check server in the background (optional)
      python3 /usr/local/bin/health_check_server.py &

      # Remove '--server' from the arguments
      COMMAND=$(echo "$@" | sed 's/--server//')

      # Loop to run parsedmarc and handle termination signals
      while true; do
        run_parsedmarc
        # If run_parsedmarc exits the script upon error, this line is not reached
        # Sleep for 300 seconds (5 minutes) before restarting
        echo "sleep mode for 300 seconds"
        sleep 300
      done
    else
      # If not in server mode, execute the command directly
      echo "client mode"
      exec "$@"
    fi
    ;;
  "shell")
    # Start an interactive shell
    exec sh
    ;;
  *)
    echo "Usage: $0 {parsedmarc|checkdmarc|shell} additional_arguments"
    exit 1
    ;;
esac
