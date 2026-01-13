#!/usr/bin/env bash
set -euo pipefail

# Validate input
if [[ $# -lt 1 || ! -f "$1" ]]; then
  echo "Usage: $0 <result-file>"
  exit 1
fi

# Ensure this is a PR event
if [[ ! -f "$GITHUB_EVENT_PATH" ]]; then
  echo "GITHUB_EVENT_PATH not set, skipping comment"
  exit 0
fi

PR_NUMBER=$(jq -r '.pull_request.number // empty' "$GITHUB_EVENT_PATH")

if [[ -z "$PR_NUMBER" ]]; then
  echo "Not a PR event, skipping comment"
  exit 0
fi

# Read result safely
RESULT=$(cat "$1")

BODY=$(jq -n --arg body "### 🚦 CI Load Test Results
\`\`\`
$RESULT
\`\`\`" \
'{ body: $body }')

curl -sS -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR_NUMBER/comments" \
  -d "$BODY"