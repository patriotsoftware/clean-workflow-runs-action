#!/bin/bash

echo "Getting all completed run(s) for workflow $WORKFLOW_NAME in $REPOSITORY"

RUNS=$(
  gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$REPOSITORY/actions/workflows/$WORKFLOW_NAME/runs" \
    --paginate \
    --jq '.workflow_runs[] | select(.conclusion != "") | .id'
)

echo "Found $(echo "$RUNS" | wc -l) workflow run(s)."

for RUN in $RUNS; do  
  # gh run delete --repo $REPOSITORY $RUN || echo "Failed to delete run $RUN"
  https://github.com/$REPOSITORY/actions/runs/$RUN
  sleep 0.1
done