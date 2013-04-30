#!/usr/bin/env bash

set -ex

SRC_REPO=$1
DST_REPO=$2
DST_FOLDER=$3

# create temporary repository
DIR=$(mktemp -d)
cd $DIR
git init

# connect to source repository
git remote add src $SRC_REPO
git remote update

# connect to destination repository
git remote add dst $DST_REPO

# duplicate all branches from source repo to destination repo
BRANCHNAMES=$(git branch -r | grep -v HEAD | cut -d'/' -f2)
for BRANCHNAME in $BRANCHNAMES; do
    git push dst src/$BRANCHNAME:refs/heads/$DST_FOLDER/$BRANCHNAME
done

# cleanup
cd -
rm -rf $DIR

