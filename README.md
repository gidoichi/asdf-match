# asdf-match
asdf-match matches plugin version to desired one with a command not depends on the desired CLI tool version like:

```sh
asdf-match "$name"
```

[asdf](https://github.com/asdf-vm/asdf) can just manage CLI tool versions, but you need to change these versions with specified version number.  
asdf-match is an extention/wrapper of asdf for convenient use.

## Installation
```sh
curo -o /usr/local/bin/asdf-match https://raw.githubusercontent.com/gidoichi/asdf-match/master/bin/asdf-match
```

## Configuration
You only need to define a command outputs desired version for each plugins and set the command to the environment variable named `ASDFMATCH_DESIRED_VER_FUNC_${NAME}` (`${NAME}` should be UPPER_CAMMEL_CASE of the plugin.)

```sh
export "ASDFMATCH_DESIRED_VER_FUNC_${NAME}"=/path/to/desired_version
chmod +x "ASDFMATCH_DESIRED_VER_FUNC_${NAME}"
cat <<EOF > "ASDFMATCH_DESIRED_VER_FUNC_${NAME}"
#!/bin/sh
echo '1.0.0'
EOF
```

Optionally, when `ASDFMATCH_CURRENT_VER_FUNC_${NAME}` environment variable is defined, this functions is used to detect current CLI tool version.

## Basic Usage
### e.g. [kubectl](https://github.com/kubernetes/kubectl)
Consider you use multiple Kubernetes clusters and these clusters are not same version. You should switch kubectl version to cluster version many times.  
Fortunately [kube-ps1](https://github.com/jonmosco/kube-ps1) calls `KUBE_PS1_CLUSTER_FUNCTION` at cluster switched.

So, with following settings in your shell initialization scripts (e.g. .bashrc) you no longer types `asdf global kubectl <version>`.

```sh
export ASDFMATCH_DESIRED_VER_FUNC_KUBECTL="$HOME/.local/bin/kubectl_desired_version.sh"
chmod +x "$ASDFMATCH_DESIRED_VER_FUNC_KUBECTL"
cat <<EOF > "$ASDFMATCH_DESIRED_VER_FUNC_KUBECTL"
#!/bin/sh
v=$(kubectl version --output=json)
printf '%s' "$v" |
    jq -re '.serverVersion.gitVersion' |
    sed 's/^v\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'
EOF

kube_ps1_cluster_function() {
    printf '%s' "$1"
    asdf-match kubectl >&2
}
export KUBE_PS1_CLUSTER_FUNCTION=kube_ps1_cluster_function
```

Above script depends on:
- [jq](https://github.com/jqlang/jq)
