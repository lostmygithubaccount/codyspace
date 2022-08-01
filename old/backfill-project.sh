#!/bin/bash +x

# variables
CWD=$(pwd)
REPO_PATH_BASE="/workspaces/codyspace"
SEARCH_STR="label:triage sort:created-asc"
PROJECT_NUM=22

# get project id
project_id=$(gh api graphql -f query='
  query($organization: String! $number: Int!){
    organization(login: $organization){
      projectV2(number: $number) {
        id
      }
    }
  }' -f organization=$org -F number=$PROJECT_NUM | jq '.data.organization.projectV2.id')

echo $project_id

# for each repo
repos=$(cat repos-project.txt)

readarray -t repos_array <<<"$repos"

for repo in ${repos_array[@]}
do

  echo $repo

  REPO_PATH="$REPO_PATH_BASE/$repo"

  # change directories
  cd $REPO_PATH

  # process issues
  issues=$(gh issue list \
      -S "$SEARCH_STR" \
      | cut -f1
  )
  readarray -t issues_array <<<"$issues"

  # add issues to project
  for issue in ${issues_array[@]}
  do
      # gh issue edit \
      #     --add-project "Core management" \
      #     $issue

      echo $issue
      issue_id=$(gh issue view $issue --json id -q '.id')
      echo $issue_id
      # response=$(gh api graphql -f query='
      #   mutation($project:ID!, $issue:ID!) {
      #       addProjectextItem(input: {projectId: $project, contentId: $issue}) {
      #       projectV2Item {
      #           id
      #         }
      #       }
      #   }' -f project=$project_id -f issue=$issue_id --jq '.data.addProjectNextItem.projectV2Item.id')
      response=$(gh api graphql -f query='
        mutation($project_id: ID! $issue_id: ID!) {
          addProjectV2ItemById(input: {projectId: $project_id contentId: $issue_id}) {
            item {
              id
            }
          }
        }' -f project_id=$project_id -f issue_id=$issue_id)
      echo $response

  done
done

# change back
cd $CWD

