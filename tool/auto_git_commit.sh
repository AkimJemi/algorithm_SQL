#!/bin/bash

# Navigate to the repository root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_DIR" || exit 1

echo "=========================================="
echo " Starting Auto Commit for algorithm_SQL"
echo " Repository: https://github.com/AkimJemi/algorithm_SQL.git"
echo " Directory: $REPO_DIR"
echo "=========================================="

# Check if there are any changes (modified, deleted, untracked files)
if [ -z "$(git status --porcelain)" ]; then
    echo "No changes detected in repository. Nothing to commit."
    exit 0
fi

# Determine commit message (use command line argument if provided, otherwise default to timestamp)
if [ -n "$1" ]; then
    COMMIT_MSG="$1"
else
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    COMMIT_MSG="Auto commit: $TIMESTAMP"
fi

# Get current git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

echo "Staging changes..."
git add .

echo "Committing with message: '$COMMIT_MSG'..."
git commit -m "$COMMIT_MSG"

echo "Pushing to remote origin/$BRANCH..."
git push origin "$BRANCH"

if [ $? -eq 0 ]; then
    echo "=========================================="
    echo " Success! Changes pushed to GitHub."
    echo " URL: https://github.com/AkimJemi/algorithm_SQL"
    echo "=========================================="
else
    echo "=========================================="
    echo " Error: Failed to push changes to GitHub."
    echo "=========================================="
    exit 1
fi
