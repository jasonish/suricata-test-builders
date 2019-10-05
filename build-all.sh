#! /usr/bin/env bash

set -e

topdir="$(cd $(dirname $0) && pwd)"

"${topdir}/docker-centos-7/run.sh" "$1"
"${topdir}/docker-fedora-32/run.sh" "$1"
