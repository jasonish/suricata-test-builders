#! /bin/sh

set -e
set -x

cd /src/suricata

./autogen.sh
./configure --enable-lua --enable-unittests
make -j ${CORES}
make check

if [ -e /work/suricata-verify ]; then
    /work/suricata-verify/run.py --outdir ./svout
fi
