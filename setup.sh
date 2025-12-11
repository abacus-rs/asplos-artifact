which curl || sudo apt-get install curl
mkdir -p abacus_redox
cd abacus_redox

curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/native_bootstrap.sh -o native_bootstrap.sh

time bash -e native_bootstrap.sh -y
source ~/.cargo/env

echo "[Abacus Setup Script] - Successfully setup! Now starting build..."

#git remote add abacus https://github.com/abacus-rs/redox.git
#git checkout abacus/asplos26-eval

# apply patch to drivers recipe to use our fork of the drivers repo.
#git apply ../cookbook.patch

cd redox
time make all