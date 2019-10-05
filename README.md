# Suricata Builders (for Development)

## Requirements

- Docker for Docker based builds.
- Vagrant and VirtualBox for Vagrant builds.

## To Run A Specific Build

For example, CentOS 7, from your Suricata source directory run:

    /path/to/suricata-builders/docker-centos-7/run.sh

## Issues

Each container sets up a builder user, in some cases this users UID is
fixed at build time, so these builders work best if the user creating
the containers, and the user running the containers are the same. This
should not be an issue on single user developer machines.

## Command Line Options

--skip-configure

> Skip ./autogen and ./configure.

--configure

> Exit after ./configure.

--shell

> Get a shell in the build environment (after source is copied in).

--rebuild

> For Vagrant builds, destroy the instance before build.
