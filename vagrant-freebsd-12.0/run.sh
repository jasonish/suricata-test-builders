#! /usr/bin/env bash

set -e

builder="$(cd $(dirname $0) && pwd)"
workdir="${builder}/work"
tag=$(basename ${builder})

. "${builder}/../common.sh"

if [ "$1" = "" ]; then
    source=$(pwd)
else
    source=$(realpath $1)
fi

echo "builder=${builder}"
echo "workdir=${workdir}"
echo "source=${source}"

prepare "${source}" "${workdir}"
cp build.sh "${workdir}"

vagrant_run() {
    set -x
    cd "${builder}"

    if vagrant ssh -c true > /dev/null 2>&1; then
        is_running="yes"
    else
        is_running="no"
    fi

    if [[ "${is_running}" = "no" ]]; then
        vagrant up --provider=virtualbox
    fi
    vagrant ssh-config > ./.ssh-config
    
    echo "===> Syncing source..."
    rsync -e "ssh -F .ssh-config" \
          -avz \
          --delete \
          --update \
          ./work \
          default:

    echo "===> Starting build..."
    if vagrant ssh -c "cd work && bash --login build.sh"; then
        success="yes"
    else
        success="no"
    fi

    if [[ "${is_running}" = "no" ]]; then
        vagrant halt
    fi

    if [[ "${success}" = "no" ]]; then
        echo "***> FAIL: ${builderdir}"
        exit 1
    fi
}

 vagrant_run
 
