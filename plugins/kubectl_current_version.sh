#!/bin/sh

kubectl version --client=true --output=json |
    jq -r '.clientVersion.gitVersion' |
    sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
