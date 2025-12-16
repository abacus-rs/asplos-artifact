git clone https://github.com/abacus-rs/tock

sudo apt install gcc-arm-none-eabi gcc-riscv64-unknown-elf -y

source ~/.bashrc

cd tock && make -C boards/nordic/nrf52840dk
