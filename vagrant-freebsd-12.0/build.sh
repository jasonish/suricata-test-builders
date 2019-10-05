#! /bin/sh

set -e

cd suricata
if ! test -e ./configure; then
    ./autogen.sh
fi
./configure
make -j2
