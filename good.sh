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
svn export https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5
cd test5

git init
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:$USERNAME/test5.git
git push -u origin master


git config --add svn-remote.hedgehog.url https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5
git config --add svn-remote.hedgehog.fetch :refs/remotes/hedgehog


git svn fetch hedgehog -r 79576:HEAD


git checkout -b local-hedgehog -t hedgehog
git svn rebase hedgehog

git checkout master
echo "i'm making a change in git" >> README.md
git add README.md
git commit -m "made a change in git"
git push origin master


git checkout local-hedgehog

set +e
git merge master
set -e
#oops, there are conflicts, so:
git checkout --theirs README.md
git add README.md
git commit -m "getting a change from git"
git svn dcommit # it works!

git svn rebase # works!
