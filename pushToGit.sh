#!/bin/bash

# Check if the commit message parameter is missing
if [ -z "$1" ]; then
    echo "❌ Error: Commit message is required."
    echo "Usage: ./deploy.sh \"your commit message\""
    exit 1
fi

# Store the commit message
COMMIT_MSG="$1"

# Run Git commands
git add -A
git commit -m "$COMMIT_MSG"
git push
