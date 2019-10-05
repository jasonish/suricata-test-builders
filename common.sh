set -e

libhtp_repo="https://github.com/OISF/libhtp"
libhtp_branch="0.5.x"

build_dist() {
    source="$1"
    workdir="$2"
    rm -rf "${workdir}/suricata"
    mkdir -p "${workdir}/suricata"
    (cd "${source}" && git ls-files -z | \
             xargs -0 tar cf - | \
             (cd "${workdir}/suricata" && tar xf -))
    if test -e "${source}/libhtp/autogen.sh"; then
        echo "Using bundled libhtp"
        mkdir -p "${workdir}/suricata/libhtp"
        (cd "${source}/libhtp" && git ls-files -z | \
                 xargs -0 tar cf - | \
                 (cd "${workdir}/suricata/libhtp" && tar xf -))
    else
        echo "Bundling ${libhtp_repo}: branch ${libhtp_branch}"
        (cd "${workdir}/suricata" && \
             git clone "${libhtp_repo}" -b "${libhtp_branch}")
    fi
}

prepare() {
    source="$1"
    workdir="$2"
    if test -d "${source}"; then
        build_dist "${source}" "${workdir}"
    else
        rm -rf "${workdir}/suricata"
        mkdir -p "${workdir}/suricata"
        (cd "${workdir}/suricata" && tar xvf "${source}" --strip-components 1)
    fi
}
