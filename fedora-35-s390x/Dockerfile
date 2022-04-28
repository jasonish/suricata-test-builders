FROM s390x/fedora:35

RUN dnf -y install \
    autoconf \
    automake \
    cargo \
    ccache \
    clang \
    diffutils \
    file-devel \
    gcc \
    gcc-c++ \
    git \
    hiredis-devel \
    jansson-devel \
    jq \
    lua-devel \
    libasan \
    libtool \
    libyaml-devel \
    libnfnetlink-devel \
    libnetfilter_queue-devel \
    libnet-devel \
    libcap-ng-devel \
    libevent-devel \
    libmaxminddb-devel \
    libpcap-devel \
    libtool \
    lz4-devel \
    make \
    nss-softokn-devel \
    pcre2-devel \
    pkgconfig \
    python3-yaml \
    sudo \
    which \
    zlib-devel
RUN cargo install cbindgen
ENV PATH=/root/.cargo/bin:$PATH
