#!/bin/bash

collect_runs() {
  RUNS=$(
    gh api \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "/repos/$REPOSITORY/actions/$1" \
      --paginate \
      --jq '.workflow_runs[] | ' + $2 + ' | .id'
  )   
}

get_expired() {
  date=$(date -d "$DAYS_AGO days ago" +%s)
  formatted_date=$(date -d @${date} +'%Y-%m-%d %H:%M:%S')
  github_date=$(date -d @${date} +'%Y-%m-%dT%H:%M:%S-04:00')
  echo "Getting all workflows in $REPOSITORY older than $DAYS_AGO days or before $formatted_date"

  collect_runs 'runs?per_page=100' 'select(.created_at < "'$github_date'")'
}

get_workflow() {
  echo "Getting all completed run(s) for workflow $WORKFLOW_NAME in $REPOSITORY"

  collect_runs 'workflows/$WORKFLOW_NAME/runs' 'select(.conclusion != "")'
}

if [ -z "${WORKFLOW_NAME}" ]; then
  get_expired
else
  get_workflow
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
    gh run delete --repo $REPOSITORY $RUN || echo "Failed to delete run $RUN"
    sleep 0.1
  done
}

if [ $TEST = "true" ]; then  
  test_run
else  
  delete_workflows
fi