#!/bin/bash

# installs
brew install tree cloc

# clone repositories - I never learned for loops

## Core stuff
gh repo clone $org/dbt-core
gh repo clone $org/dbt-snowflake
gh repo clone $org/dbt-redshift
gh repo clone $org/dbt-bigquery
gh repo clone $org/dbt-spark
gh repo clone $org/dbt-databricks

## "Core" stuff
gh repo clone $org/actions
gh repo clone $org/dbt-rpc
gh repo clone $org/dbt-server
gh repo clone $org/dbt-utils
gh repo clone $org/dbt-starter-project

## Examples
gh repo clone $org/jaffle_shop
gh repo clone $org/jaffle_shop_duckdb

## Other
gh repo clone $org/internal-analytics
gh repo clone $org/docs.getdbt.com

## it's fine
exit 0
