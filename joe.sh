#!/bin/bash

set -e
set -x

USERNAME=dtenenba

rm -rf joe
git clone git@github.com:$USERNAME/joe.git
cd joe
git config --add svn-remote.hedgehog.url https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5
git config --add svn-remote.hedgehog.fetch :refs/remotes/hedgehog
git svn fetch hedgehog -r 79576:HEAD

git checkout -b local-hedgehog -t hedgehog
git svn rebase hedgehog

git svn dcommit

# git checkout master
# echo "made a change in git" >> README.md
# git add README.md
# git commit -m "made a change in git"
# git push origin master

# git checkout local-hedgehog
set +e
#git merge master
set -e

#git add README.md
set +e
#git commit -m "merging change from git"
set -e
echo "hiiii"
set +e
git svn dcommit #fails
set -e

echo "done"
