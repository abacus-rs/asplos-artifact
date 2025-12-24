#!/bin/bash
# Conduct eval using Abacus xHCI.

# exit on errors
set -e

rm -rf results
mkdir -p results

cd abacus_redox/redox

# Apply patch for abacus-redox to Redox recipe.
git apply ../../abacus-profile.patch
rm -rf recipes/core/base/source
make r.base && make image
../../get_redox_qemu_cycle_count.sh 15 
cp cycle_result.csv ../../results/abacus_redox_xhci_cycle_result.csv

# Remove patch.
git reset --hard a2ce30b797882ffdbc3660edbfa5507dd23619ee

# Apply patch for baseline Redox recipe.
git apply ../../base-profile.patch
rm -rf recipes/core/base/source
make r.base && make image
../../get_redox_qemu_cycle_count.sh 15
cp cycle_result.csv ../../results/baseline_redox_xhci_cycle_result.csv

cd ../..

# Compare results.
python3 compare_eval_runs.py
