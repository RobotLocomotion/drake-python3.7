#!/bin/bash
#
# Install development and runtime prerequisites for binary distributions of
# Drake on Ubuntu 18.04 (Bionic) or 20.04 (Focal).

set -euo pipefail

with_update=1

while [ "${1:-}" != "" ]; do
  case "$1" in
    # Do NOT call apt-get update during execution of this script.
    --without-update)
      with_update=0
      ;;
    *)
      echo 'Invalid command line argument' >&2
      exit 3
  esac
  shift
done

if [[ "${EUID}" -ne 0 ]]; then
  echo 'ERROR: This script must be run as root (sudo -H)' >&2
  exit 1
fi

if command -v conda &>/dev/null; then
  echo 'WARNING: Anaconda is NOT supported for building and using the Drake Python bindings' >&2
fi

binary_distribution_called_update=0

if [[ "${with_update}" -eq 1 ]]; then
  apt-get update || (sleep 30; apt-get update)

  # Do NOT call apt-get update again when installing prerequisites for source
  # distributions.
  binary_distribution_called_update=1
fi

apt-get install --no-install-recommends lsb-release

codename=$(lsb_release -sc)

if [[ "${codename}" != 'bionic' && "${codename}" != 'focal' ]]; then
  echo 'ERROR: This script requires Ubuntu 18.04 (Bionic) or 20.04 (Focal)' >&2
  exit 2
fi

# Ensure that we have available a locale that supports UTF-8 for pip3 install
# and for generating a C++ header containing Python API documentation during
# the build.
apt-get install --no-install-recommends locales
locale-gen en_US.UTF-8

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

packages=$(cat "${BASH_SOURCE%/*}/packages-${codename}.txt")
apt-get install --no-install-recommends ${packages}

apt-get install --no-install-recommends $(cat <<EOF
  ca-certificates
  build-essential
  wget
EOF
)

apt-get remove --auto-remove $(cat <<EOF
  python3-ipython
  python3-ipywidgets
  python3-matplotlib
  python3-notebook
  python3-numpy
  python3-pip
  python3-pydot
  python3-pygame
  python3-scipy
  python3-setuptools
  python3-tornado
  python3-u-msgpack
  python3-wheel
  python3-yaml
  python3-zmq
EOF
)

export PIP_NO_SETUPTOOLS=1
export PIP_NO_WHEEL=1

wget -qO- https://bootstrap.pypa.io/get-pip.py | python3

python3 -m pip install -c "${BASH_SOURCE%/*}/constraints.txt" setuptools wheel

python3 -m pip install \
  -c "${BASH_SOURCE%/*}/constraints.txt" \
  -r "${BASH_SOURCE%/*}/requirements.txt"
