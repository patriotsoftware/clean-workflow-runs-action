#!/bin/bash

if [ -z "${WORKFLOW_NAME}" ]
then
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
else
    echo "Getting all completed run(s) for workflow $WORKFLOW_NAME in $REPOSITORY"

    RUNS=$(
      gh api \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/$REPOSITORY/actions/workflows/$WORKFLOW_NAME/runs" \
        --paginate \
        --jq '.workflow_runs[] | select(.conclusion != "") | .id'
    ) 
fi

echo "Found $(echo "$RUNS" | wc -l) workflow run(s)."

test_run() {
  for RUN in $RUNS; do 
    echo "https://github.com/$REPOSITORY/actions/runs/$RUN"
    sleep 0.1
  done
}

delete_workflows() {
  for RUN in $RUNS; do 
    echo "Delete was triggered: https://github.com/$REPOSITORY/actions/runs/$RUN"
    # gh run delete --repo $REPOSITORY $RUN || echo "Failed to delete run $RUN"
    sleep 0.1
  done
}

if [ $TEST = "true" ]; then  
  test_run
else  
  delete_workflows
fi