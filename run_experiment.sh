# Script for running Abacus / Redox eval.

# Run setup script, retrying up to 5 times if it fails.
for i in {1..5}; do
    ./setup.sh && break
    echo "Setup script failed, retrying... ($i/5)"
    sleep 2
done

# make r.drivers && make image && ./run_exp.sh 1
