#!/bin/bash

set -x

PW=`cat pw`
# edit this:
USERNAME=dtenenba


curl -u $USERNAME:$PW -X DELETE https://api.github.com/repos/$USERNAME/test5

set -e

sleep 1

curl -u $USERNAME:$PW -d '{"name": "test5"}' -X POST https://api.github.com/user/repos


rm -rf test5
git clone git@github.com:$USERNAME/test5.git
cd test5


git config --add svn-remote.hedgehog.url https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5
git config --add svn-remote.hedgehog.fetch :refs/remotes/hedgehog


git svn fetch hedgehog -r 79576:HEAD


git checkout -b local-hedgehog -t hedgehog
git svn rebase hedgehog


git checkout master
echo "adding a line in git" >> README.md
git add README.md
git commit -m "adding a line in git"
git push origin master

git checkout local-hedgehog
git merge master
git add README.md
set +e
git commit -m "merging change from git"
set -e
git svn dcommit

