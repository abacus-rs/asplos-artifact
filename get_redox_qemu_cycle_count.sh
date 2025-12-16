#!/bin/zsh
# Script to run QEMU N times, then mount and copy cycle_result.csv

cd abacus_redox/redox

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <N>"
    exit 1
fi

N=$1
for i in {1..$N}
do
    echo "Run $i/$N: Starting QEMU..."
    make qemu gpu=no audio=no debug=yes kvm=no ARCH=x86_64 &
    VM_PID=$!
    sleep 30
    echo "Killing QEMU (PID $VM_PID)..."
    kill $VM_PID
    # Kill any remaining qemu processes
    pkill -f qemu-system-x86_64
    # Wait for process to exit and file locks to be released
    wait $VM_PID 2>/dev/null
    sleep 5
    # Optional: wait for process to exit
    wait $VM_PID 2>/dev/null
    echo "Run $i/$N: Done."
done

echo "Running make mount..."
make mount

echo "Copying cycle_result.csv..."
cp build/x86_64/desktop/filesystem/home/user/cycle_result.csv .
make unmount

echo "All done."

