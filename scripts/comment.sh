#!/usr/bin/env bash
set -e

if [[ -z "$PR_NUMBER" || "$PR_NUMBER" == "null" ]]; then
  echo "Not running in PR context, skipping comment"
  exit 0
fi

RESULT=$(sed 's/"/\\"/g' "$1")

BODY=$(jq -n --arg body "### 🚦 CI Load Test Results\n\`\`\`\n$RESULT\n\`\`\`" \
  '{ body: $body }')

PR_NUMBER=$(jq -r .pull_request.number "$GITHUB_EVENT_PATH")

curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR_NUMBER/comments" \
  -d "$BODY"