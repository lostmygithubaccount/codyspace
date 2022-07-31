#!/bin/bash +x

# setup git
unset GITHUB_TOKEN
echo $CODESPACE_PAT | gh auth login --with-token
gh auth setup-git
git config --global user.email "cody.dkdc2@gmail.com"
git config --global user.name "Cody Peterson"
git config --global pull.rebase false
