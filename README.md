# Suricata Test Builders

## Setup

To build non x86_64 images on x86_64 qemu-multiarch must first be setup:

```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

## Usage Example

```
cd fedora-35-x86_64
../run.sh --suricata-verify /path/to/suricata-verify /path/to/suricata-src
```
