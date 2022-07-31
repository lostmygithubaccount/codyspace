#!/bin/bash

# get array of repos
repos=$(cat "repos-local.txt")
readarray -t repos_array <<<$repos

# clone each repo
for repo in ${repos_array[@]}
do
    echo $repo
    gh repo clone $repo
done
