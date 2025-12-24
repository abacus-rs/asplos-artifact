#!/usr/bin/env bash
set -euo pipefail

# Root of your Redox source tree
REDOX_ROOT="${1:-.}"  # default to current directory

# Date to pin to
PIN_DATE="2025-12-15"

# Find all Git repos recursively
repos=$(find "$REDOX_ROOT" -name ".git" -type d)

for gitdir in $repos; do
    repo_dir=$(dirname "$gitdir")
    echo "==== Processing repo: $repo_dir ===="
    pushd "$repo_dir" > /dev/null

    # Find the latest commit on or before PIN_DATE
    commit=$(git rev-list -1 --before="$PIN_DATE 23:59:59" HEAD)
    if [ -z "$commit" ]; then
        echo "No commit found before $PIN_DATE in $repo_dir"
    else
        echo "Checking out commit $commit"
        git checkout -f "$commit"
    fi

    popd > /dev/null
done

echo "All repositories pinned to $PIN_DATE commits."
