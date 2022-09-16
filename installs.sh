#!/bin/bash

# brew installs
brew install tree cloc

# linux
apt-get update && apt-get upgrade -y

# wild
apt-get install libsasl2-dev

# python installs
pip install --upgrade pip # yolo
pip install -r requirements.txt
