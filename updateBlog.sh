#!/bin/bash
# Description: update my blog
# Author: Lv Xiaoteng
# Date: 2018-07-28
# Email: helleo.cn@gmail.com
# WebSite: https://yeaheo.com

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
msg="rebuilding site `date`"

if [ $# -eq 1 ]
  then msg="$1"
fi

# Push Hugo content
git add -A
git commit -m "$msg"
git push origin master

# Build the project. 
hugo

# Go To Public folder
cd public

# Add changes to git.
git add -A

# Commit changes.
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..