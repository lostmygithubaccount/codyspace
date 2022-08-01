#!/usr/local/bin/python

# imports
import os
import click
import requests

# TODO: improve
from graphql_queries import *

# TODO: what is error handling?

# constants # TODO: move to a config file (or something) <= copilot suggested this last part
ORG = "dbt-labs"
PROJECT_NAME = "Core management"
PROJECT_NUM = 22
# read newline separated list of projects from file
PROJECT_REPOS = open("repos-project.txt", "r", encoding="utf-8").read().splitlines()

# API stuff
headers = {"Authorization": f"token {os.environ.get('CODESPACE_PAT')}"}
graphql_url = "https://api.github.com/graphql"


def _process_request(url, headers, json=None):
    if json:
        r = requests.post(url, headers=headers, json=json)
    else:
        r = requests.get(url, headers=headers)

    return r.json()


def _get_core_members(teams=["core"]) -> list:
    # initialize empty list
    core_members = []

    # for each core team, add its members
    for team in teams:
        url = f"https://api.github.com/orgs/{ORG}/teams/{team}/members"
        r = _process_request(url, headers=headers)

        team_members = [login["login"] for login in r]
        core_members.extend(team_members)

    return sorted(list(set(core_members)))


# build click CLI
@click.group()
def cli():
    pass


# star of run command
@click.command()
@click.option("--preview", "-p", default=False, help="Preview instead of running.")
@click.option(
    "--repo",
    "-r",
    default="dbt-core",
    help="Repo to backfill to {PROJECT_NAME} project.",
)
@click.option(
    "--item-type", "-i", default="issue", help='"issue" only. "pr" to be implemented'
)
@click.option("--label", "-l", default="triage", help="Label to filter on.")
@click.option("--num_items", "-n", default=100, help="Number of issues to backfill.")
@click.option("--run-all", "-A", default=False, help="Run all in repos-project.txt")
def run(preview, repo, item_type, label, num_items, run_all):
    def _get_project_id():
        project_id = _process_request(
            graphql_url,
            headers=headers,
            json={
                "query": project_id_query.replace("$org", f'"{ORG}"').replace(
                    "$project_num", f"{PROJECT_NUM}"
                )
            },
        )["data"]["organization"]["projectV2"]["id"]
        return project_id

    def _get_issues(repo):
        issues = _process_request(
            graphql_url,
            headers=headers,
            json={
                "query": issues_query.replace("$org", f'"{ORG}"')
                .replace("$repo", f'"{repo}"')
                .replace("$num_items", f"{num_items}")
                .replace("$label", f'"{label}"')
            },
        )["data"]["repository"]["issues"]["edges"]
        return issues

    def _add_items_to_project(items):
        for item in items:
            click.echo(f"Item: {item}")
            response = _process_request(
                graphql_url,
                headers=headers,
                json={
                    "query": add_item_to_project_mutation.replace(
                        "$project_id", f'"{project_id}"'
                    ).replace("$item_id", f'"{item["node"]["id"]}"')
                },
            )
            click.echo(f"Response: {response}")

    def _process_repo(repo):
        click.echo(f"Processing {repo}...")
        issues = _get_issues(repo)
        # click.echo(f"Issues: {issues}")
        _add_items_to_project(issues)

    project_id = _get_project_id()
    click.echo(f"Project ID: {project_id}")

    if run_all:
        repos = PROJECT_REPOS  # TODO: improve
        for repo in repos:
            _process_repo(repo)
    elif repo:
        _process_repo(repo)

    return 0


cli.add_command(run)
# end of run command

if __name__ == "__main__":
    cli()
