#!/bin/bash

if [ -z "${WORKFLOW_NAME}" ]
then
    date=$(date --date='$DAYS_AGO days ago' --iso-8601='seconds')
    echo "Getting all workflows in $REPOSITORY older than $DAYS_AGO or before $date"
    
    RUNS=$(
      gh api \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/$REPOSITORY/actions/workflows/$WORKFLOW_NAME/runs" \
        --paginate \
        --jq '.workflow_runs[] | select(.created_at < "'$date'") | .id'
    ) 
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
  sleep 0.1
done