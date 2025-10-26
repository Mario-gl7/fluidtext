#!/bin/bash
# Usage: ./create_repo.sh repo-name
REPO_NAME="Fluid"
if [ -z "$REPO_NAME" ]; then
  echo "Usage: ./create_repo.sh <repo-name>"
  exit 1
fi
git init
git add .
git commit -m "Initial commit: LinguaReader full release"
git checkout --orphan independent_branch
git commit --allow-empty -m "Initial commit in independent branch"
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
echo "Repository created. Remember to set secrets: PONS_API_KEY"
