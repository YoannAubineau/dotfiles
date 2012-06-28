#!/usr/bin/env bash

BRANCH=$1

git remote update

COMMIT=$(git reflog show origin/$BRANCH | awk 'PRINT_NEXT==1{print $1; exit} /: forced-update/{PRINT_NEXT=1}')
git rebase --onto origin/$BRANCH $COMMIT $BRANCH

