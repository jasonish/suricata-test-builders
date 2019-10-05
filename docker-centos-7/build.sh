#! /usr/bin/env bash

set -e

case "$(uname)" in
    Linux)
        cpus=$(grep -c ^processor /proc/cpuinfo)
        if [ "${cpus}" -gt 1 ]; then
            cpus=$(expr ${cpus} / 2)
        fi
        ;;
    *)
        # Just assume 2...
        cpus=2
        ;;
esac

if ! test -e ./configure; then
    ./autogen.sh
fi
./configure --enable-unittests
make -j "${cpus}"
make check
sudo env PATH=$PATH make install
sudo env PATH=$PATH  make install-conf
if test -e ./suricata-update/setup.py; then
    sudo env PATH=$PATH make install-rules
fi
make clean
