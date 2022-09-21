#!/bin/bash

## clone repos
/bin/bash +x clone-repos.sh

## installs
/bin/bash +x installs.sh

## for venvs
mkdir $cs/venvs

## assume all is well
exit 0
