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

cd "${builder}"
docker build --build-arg REAL_UID=$(id -u) -t ${tag} .
docker run --rm -it -w /work/suricata ${tag} ../build.sh
