#!/usr/bin/env bash

set -eou pipefail

# set -x

for j in {0..99}
do
    for i in {0..99}
    do
        BRANCH_NAME="branch-$(date +%s)-$(date +%s%N | sha256sum | base64 | head -c 8)-${i}"
        git checkout -b $BRANCH_NAME -q

        RANDOM_TEXT="$(date +%s%N | sha256sum | base64 | head -c 32)-${i}"
        echo $RANDOM_TEXT > file.txt

        git add file.txt
        git commit -m "Add random text to file.txt"
        # git push origin $BRANCH_NAME -q
    done

    git push --all

    set -x

    git checkout latest-publish-main -q
    git reset --hard $BRANCH_NAME
    git push -f origin latest-publish-main

    set +x
done
