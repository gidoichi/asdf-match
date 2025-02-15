#!/bin/sh

set -eu

v=$(kubectl version --output=json)
printf '%s' "$v" |
    jq -re '.serverVersion.gitVersion' |
    sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
