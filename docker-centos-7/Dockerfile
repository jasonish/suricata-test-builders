FROM centos:7

RUN yum -y install epel-release
RUN yum -y install \
        autoconf \
        automake \
        cargo \
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
        nss-devel \
        pcre-devel \
        pkgconfig \
        rust \
        sudo \
        which \
        zlib-devel

# Install Python 2 dependencies.  As of Suricata 5.0, configure will
# not pickup Python 3 on CentOS 7 as its named python34, and not
# python3.
RUN yum -y install python2-pyyaml

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

