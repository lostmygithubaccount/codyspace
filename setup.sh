#!/bin/bash

## installs
/bin/bash +x installs.sh

## clone repos
/bin/bash +x clone-repos.sh

## auth
source auth.sh

## assume all is well
exit 0
