#!/usr/bin/env sh

asdfmatch_current_version_kubectl() {
    kubectl version --client=true --output=json |
        jq -r '.clientVersion.gitVersion' |
        sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
}

asdfmatch_desired_version_kubectl() {
    v=$(kubectl version --output=json)
    printf '%s' "$v" |
        jq -re '.serverVersion.gitVersion' |
        sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
}

export ASDFMATCH_DESIRED_VER_FUNC_KUBECTL=asdfmatch_desired_version_kubectl
