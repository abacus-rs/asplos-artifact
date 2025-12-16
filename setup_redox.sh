#!/bin/bash
which curl || sudo apt-get install curl
mkdir -p abacus_redox
cd abacus_redox

# Retry on error 5 times.
for i in {1..5}; do
  # Run redox provided setup scripts.
  curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/native_bootstrap.sh -o native_bootstrap.sh
  
  time bash -e native_bootstrap.sh -y
  source ~/.cargo/env
  
  echo "[Abacus Setup Script] - Successfully setup! Now starting build..."
  
  cd redox
  time make all

done