#! /bin/bash

set -e

LIBHTP_DIR=""
SURICATA_UPDATE_DIR=""
SURICATA_VERIFY_DIR=""
COMMAND="/work/_build.sh"
DOCKER="docker"

CORES=$(cat /proc/cpuinfo | grep '^processor'|wc -l)

while [[ $# -gt 0 ]]; do
    echo "-- ${1} ${2}"
    case $1 in
        --libhtp)
            LIBHTP_DIR=$2
            shift
            shift
            ;;
        --suricata-update)
            SURICATA_UPDATE_DIR=$2
            shift
            shift
            ;;
        --suricata-verify)
            SURICATA_VERIFY_DIR=$2
            shift
            shift
            ;;
        --shell)
            COMMAND="/bin/sh"
            shift
            ;;
        --podman)
            DOCKER="podman"
            shift
            ;;
        --*)
            echo "error: unknown otion: $1"
            exit 1
            ;;
        *)
            break
    esac
done

SURICATA_DIR="$1"

if [ "${SURICATA_DIR}" == "" ]; then
    echo "usage: $0 [--libhtp DIR] [--suricata-update DIR] [--suricata-verify DIR] <SURICATA_DIR>"
    exit 1
fi

if [ ! -e "${SURICATA_DIR}" ]; then
    echo "error: ${SURICATA_DIR} does not exist"
    exit 1
fi

if [ "${LIBHTP_DIR}" = "" -a -e "${SURICATA_DIR}/libhtp" ]; then
    LIBHTP_DIR=${SURICATA_DIR}/libhtp
fi

echo "===> SURICATA_DIR=$1"
echo "===> LIBHTP_DIR=${LIBHTP_DIR}"
echo "===> SURICATA_UPDATE_DIR=${SURICATA_UPDATE_DIR}"
echo "===> SURICATA_VERIFY_DIR=${SURICATA_VERIFY_DIR}"
echo "===> COMMAND=${COMMAND}"

MYDIR=$(pwd)
TAG=suricata-test-builds/$(basename $(pwd))

# Build with no context to avoid maintaining .dockerignore files.
${DOCKER} build -t ${TAG} - < Dockerfile

# Copy Suricata source.
mkdir -p src
echo "===> Copying ${SURICATA_DIR}"
(cd ${SURICATA_DIR} && git archive --format tar --prefix suricata/ HEAD | (cd ${MYDIR}/src && tar xf -))
if [ "${LIBHTP_DIR}" != "" ]; then
    echo "===> Copying ${LIBHTP_DIR}"
    (cd ${LIBHTP_DIR} && git archive --format tar --prefix libhtp/ HEAD | (cd ${MYDIR}/src/suricata && tar xf -))
elif [ ! -e "${MYDIR}/src/suricata/libhtp" ]; then
    echo "===> Cloning https://github.com/OISF/libhtp"
    (cd ${MYDIR}/src/suricata && git clone https://github.com/OISF/libhtp)
fi

VOLUMES=(
    -v $(pwd):/work:z
    -v $(pwd)/src:/src:z
)

if [ "${SURICATA_VERIFY_DIR}" != "" -a -e "${SURICATA_VERIFY_DIR}" ]; then
    VOLUMES+=(-v ${SURICATA_VERIFY_DIR}:/work/suricata-verify:z,ro)
fi

set -x

${DOCKER} run --rm -it \
    -e CORES=${CORES} \
    ${VOLUMES[@]} \
    -w /src ${TAG} ${COMMAND}
