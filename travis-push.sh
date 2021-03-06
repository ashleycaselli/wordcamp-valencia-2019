#!/bin/sh
# Credit: https://gist.github.com/willprice/e07efd73fb7f13f917ea

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_compiled_stylesheet() {
  git checkout master
  # Current month and year, e.g: Apr 2018
  dateAndMonth=`date "+%b %Y"`
  # Stage the compiled stylesheet
  git add -f style.css
  # Create a new commit with a custom build message
  # with "[skip ci]" to avoid a build loop
  # and Travis build number for reference
  git commit -m "Travis update: $dateAndMonth (Build $TRAVIS_BUILD_NUMBER)" -m "[skip ci]"
}

upload_file() {
  # Remove existing "origin"
  git remote rm origin
  # Add new "origin" with access token in the git URL for authentication
  git remote add origin https://ashleycaselli:${GH_TOKEN}@github.com/ashleycaselli/wordcamp-valencia-2019.git > /dev/null 2>&1
  git push origin master --quiet
}

setup_git

commit_compiled_stylesheet

# Attempt to commit to git only if "git commit" succeeded
if [ $? -eq 0 ]; then
  echo "A new commit with an updated stylesheet exists. Uploading to GitHub"
  upload_file
else
  echo "No changes in the stylesheet. Nothing to do"
fi