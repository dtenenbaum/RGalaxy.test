#!/bin/bash

set -x

PW=`cat pw`
# edit this:
USERNAME=dtenenba


curl -u $USERNAME:$PW -X DELETE https://api.github.com/repos/$USERNAME/test5

set -e

sleep 1

curl -u $USERNAME:$PW -d '{"name": "test5"}' -X POST https://api.github.com/user/repos




rm -rf test5/
git clone git@github.com:$USERNAME/test5.git
cd test5
git config --add svn-remote.hedgehog.url https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5
git config --add svn-remote.hedgehog.fetch :refs/remotes/hedgehog

#git remote add origin git@github.com:$USERNAME/test5.git
echo "some bad content" > README.md
#git init
git add README.md
git commit -m 'first commit'
git push -u origin master

git svn fetch hedgehog -r 79576:HEAD
git checkout -b local-hedgehog -t hedgehog
git svn rebase hedgehog



git checkout local-hedgehog
#git checkout master
set +e
git merge master
set -e
git checkout --theirs README.md
git add README.md
git commit -m "resolved initial conflict"
git svn dcommit # FAIL!


