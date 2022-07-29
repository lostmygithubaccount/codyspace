#!/bin/bash

# I never learned for loops

orgs_array=("lostmygithubaccount" "$org")

for org in ${orgs_array[@]}
do
    echo $org
    repos=$(cat "$org-repos.txt")

    readarray -t repos_array <<<$repos

    for repo in ${repos_array[@]}
    do
        echo $org/$repo
        gh repo clone "$org/$repo"
    done

done
