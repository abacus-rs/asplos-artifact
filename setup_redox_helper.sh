#!/bin/bash
which curl || sudo apt-get install curl
mkdir -p abacus_redox
cd abacus_redox

set -e

# Run redox provided setup scripts.
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/native_bootstrap.sh -o native_bootstrap.sh

time bash -e native_bootstrap.sh -y
source ~/.cargo/env
source ~/.bashrc

echo "[Abacus Setup Script] - Successfully setup! Now starting build..."

cd redox
# Pinned commit.
git checkout a2ce30b797882ffdbc3660edbfa5507dd23619ee
time make all

