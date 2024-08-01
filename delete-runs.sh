#!/bin/bash

if [ -z "${WORKFLOW_NAME}" ]
then
    # date=$(date --date='$DAYS_AGO days ago' --iso-8601='seconds')
    date=$(date -d "$DAYS_AGO days ago" +%s)
    formatted_date=$(date -d @${date} +'%Y-%m-%d %H:%M:%S')
    echo "Getting all workflows in $REPOSITORY older than $DAYS_AGO or before $formatted_date"
    
    RUNS=$(
      gh api \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/$REPOSITORY/actions/runs?per_page=100" \
        --paginate \
        --jq '.workflow_runs[] | select(.created_at < "'$date'") | .id'
    ) 

    echo "Found $(echo "$RUNS" | wc -l) workflow runs older than $DAYS_AGO"
else
    echo "Getting all completed runs for workflow $WORKFLOW_NAME in $REPOSITORY"

    RUNS=$(
      gh api \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/$REPOSITORY/actions/workflows/$WORKFLOW_NAME/runs" \
        --paginate \
        --jq '.workflow_runs[] | select(.conclusion != "") | .id'
    ) 

    echo "Found $(echo "$RUNS" | wc -l) completed runs for workflow $WORKFLOW_NAME"
fi

for RUN in $RUNS; do
  # gh run delete --repo $REPOSITORY $RUN || echo "Failed to delete run $RUN"
  echo "run value: $RUN"
  sleep 0.1
done