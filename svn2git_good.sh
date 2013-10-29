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

#git init
#git add README.md
#git commit -m "first commit"
#git remote add origin git@github.com:$USERNAME/test5.git
#git push -u origin master


git config --add svn-remote.hedgehog.url https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5
git config --add svn-remote.hedgehog.fetch :refs/remotes/hedgehog


git svn fetch hedgehog -r 79576:HEAD


git checkout -b local-hedgehog -t hedgehog
git svn rebase hedgehog

cd ..
rm -rf test5_svn
svn co https://hedgehog.fhcrc.org/bioconductor/trunk/madman/RpacksTesting/test5 test5_svn

cd test5_svn
echo "adding a line in svn" >> README.md
svn ci -m "adding a line in svn"
cd ../test5



git checkout local-hedgehog
git svn rebase 

git checkout master
git merge local-hedgehog

git add README.md
set +e
git commit -m "merging change from svn"

set -e

git push origin master

