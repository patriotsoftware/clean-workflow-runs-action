#!/bin/bash

date=$(date -d "$DAYS_AGO days ago" +%s)
formatted_date=$(date -d @${date} +'%Y-%m-%d %H:%M:%S')
github_date=$(date -d @${date} +'%Y-%m-%dT%H:%M:%S-04:00')
echo "Getting all workflows in $REPOSITORY older than $DAYS_AGO or before $formatted_date"

RUNS=$(
  gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$REPOSITORY/actions/runs?per_page=100" \
    --paginate \
    --jq '.workflow_runs[] | select(.created_at < "'$github_date'") | .id'
)    

for RUN in $RUNS; do  
  # gh run delete --repo $REPOSITORY $RUN || echo "Failed to delete run $RUN"
  https://github.com/$REPOSITORY/actions/runs/$RUN
  sleep 0.1
done