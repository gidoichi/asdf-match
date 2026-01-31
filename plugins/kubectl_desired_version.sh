#!/bin/sh

set -eu

if ! asdf which kubectl >/dev/null; then
    asdf set --home kubectl latest
fi

v=$(kubectl version --output=json)
printf '%s' "$v" |
    jq -re '.serverVersion.gitVersion' |
    sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
