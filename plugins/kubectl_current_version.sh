#!/bin/sh

set -eu

v=$(kubectl version --client=true --output=json)
printf '%s' "$v" |
    jq -re '.clientVersion.gitVersion' |
    sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
