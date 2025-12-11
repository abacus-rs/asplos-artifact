which curl || sudo apt-get install curl
mkdir -p ~/abacus_redox
cd ~/abacus_redox

curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/native_bootstrap.sh -o native_bootstrap.sh

time bash -e native_bootstrap.sh -y

source ~/.cargo/env