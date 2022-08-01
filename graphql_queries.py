# graphql query to get list of issues for the github repo
issues_query = """
    query {
        repository(owner:$org, name:$repo) {
            issues(last:$num_items states:OPEN filterBy: {
                labels: [$label]
            }) {
                edges {
                    node {
                        title
                        assignees(first:10) {
                            edges {
                                node {
                                    login
                                }
                            }
                        }
                        number
                        id
                        url
                        labels(first:10) {
                            edges {
                                node {
                                    name
                                }
                            }
                        }
                        participants(first:100) {
                            edges {
                                node {
                                    login
                                }
                            }
                        }
                        createdAt
                        updatedAt
                        closedAt
                        author {
                            login
                        }
                    }
                }
            }
        }
    }
"""

project_id_query = """
    query {
        organization(login: $org) {
            projectV2(number: $project_num) {
              id
            }
        }
    }
"""

add_item_to_project_mutation = """
    mutation {
        addProjectV2ItemById(input: {projectId: $project_id contentId: $item_id}) {
            item {
                id
            }
        }
    }
"""
