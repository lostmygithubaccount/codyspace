#!/bin/bash

# brew installs
brew install tree cloc

# python installs
pip install --upgrade pip # yolo
pip install -r requirements.txt

# snowsql install
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.23-linux_x86_64.bash
bash +x snowsql-1.2.23-linux_x86_64.bash
rm snowsql-1.2.23-linux_x86_64.bash
if [ ! -d "dotfiles" ]; then 
    gh repo clone dotfiles
fi
cp dotfiles/.snowsql/config ~/.snowsql/config
