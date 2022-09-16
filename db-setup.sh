#!/bin/bash

# install postgres
#sudo apt-get install -y postgresql

# start postgres
sudo service postgresql start
sudo psql -c "create user cody with superuser password 'dummy';"
sudo psql -c "create user root with superuser;"
createdb main
