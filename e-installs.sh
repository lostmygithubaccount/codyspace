#!/bin/bash +x

# get arguments
tag=${1:-latest}
echo "tag: $tag"
branch=${2-"cody/debug"}
echo "branch: $branch"

# variables
CWD=$(pwd)
e_req="editable-requirements.txt"
pip_options="--user"
default_branch="main"
repos=$(cat "repos-e.txt")
readarray -t repos_array <<<$repos

# clone each repo
for repo in ${repos_array[@]}
do
    # change into repo
    cd $repo
    
    # clear branch; local and remote
    git checkout $default_branch
    git reset --hard HEAD
    git branch -D $branch
    git push origin --delete origin/$branch

    # get latest tag
    if [ "$tag" == "latest" ]; then
        tag=$(git tag -l | tail -1 | cut -f1)
    fi
    echo "tag: $tag"

    git checkout "tags/$tag" -b $branch

    if [ -f "$e_req" ]; then
        echo "editable reqs"
        pip install $pip_options -r $e_req
    else
        echo "direct"
        pip install $pip_options -e .
    fi
    cd $CWD
done
