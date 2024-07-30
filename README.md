# clean-workflow-runs-action
Action intended to be called from any repo to clean workflow runs.


## Parameters

#### 'github-token' (required)
GitHub token github.token

#### 'repository' (required)
GitHub repository name gihub.repository.

#### 'workflow'
Name of the workflow file to clean run logs.

## Sample Use

```
  - uses: patriotsoftware/clean-workflow-runs-action@v1
    with:
      github-token: ${{ github.token }}
      repository: ${{ github.repository }}
      workflow: sonar.yml         
```