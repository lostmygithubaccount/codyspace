#!/bin/bash

unset GITHUB_TOKEN
echo $CODESPACE_PAT | gh auth login --with-token
gh auth setup-git
