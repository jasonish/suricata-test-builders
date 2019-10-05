#!/bin/bash
#
# Victor's suricata-update test script.

set -e
set -x

# skip if we don't have s-u
if [ ! -d suricata-update ]; then
    exit 0
fi

export PATH=$PATH:/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

suricata-update -V
suricata-update update-sources
suricata-update list-sources
suricata-update enable-source oisf/trafficid
CNT=$(suricata-update -q list-enabled-sources | grep "oisf/trafficid" | wc -l)
if [ $CNT -eq 1 ]; then
    echo "oisf/trafficid enabled succesfully"
else
    echo "oisf/trafficid enable failed: $CNT"
    exit 1
fi
suricata-update list-enabled-sources
suricata-update --no-test
suricata-update disable-source oisf/trafficid
CNT=$(suricata-update -q list-enabled-sources | grep "oisf/trafficid" | wc -l)
if [ $CNT -eq 0 ]; then
    echo "oisf/trafficid disabled succesfully"
else
    echo "oisf/trafficid disable failed: $CNT"
    exit 1
fi
suricata-update list-enabled-sources
suricata-update --no-test
