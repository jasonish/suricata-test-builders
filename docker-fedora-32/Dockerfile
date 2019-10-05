FROM fedora:32

RUN dnf -y install \
        autoconf \
        automake \
        cargo \
        ccache \
        diffutils \
        file-devel \
        gcc \
        gcc-c++ \
        git \
        jansson-devel \
        jq \
        lua-devel \
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
        nspr-devel \
        nss-devel \
        nss-softokn-devel \
        pcre-devel \
        pkgconfig \
        python3-yaml \
        sudo \
        which \
        zlib-devel

WORKDIR /work

ARG REAL_UID=1000

# Create builder user with sudo access.
RUN useradd --uid "${REAL_UID}" \
        --gid 0 \
        --create-home \
        --home-dir /home/builder builder
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

USER builder

RUN cargo install cbindgen
ENV PATH /home/builder/.cargo/bin:$PATH

COPY --chown=builder:root /work /work
COPY /build.sh /work
