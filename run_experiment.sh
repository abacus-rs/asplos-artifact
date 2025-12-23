#!/bin/bash
RETRIES=5
SLEEP=1
HELPER="./run_experiment_helper.sh"

if [[ ! -x "$HELPER" ]]; then
  echo "Helper not found or not executable: $HELPER" >&2
  exit 2
fi

for i in $(seq 1 $RETRIES); do
  echo "Attempt $i/$RETRIES: running $HELPER"
  if "$HELPER"; then
    echo "Success on attempt $i"
    exit 0
  fi
  echo "Attempt $i failed"
  if [[ $i -lt $RETRIES ]]; then
    echo "Retrying in ${SLEEP}s..."
    cd abacus_redox/redox || exit 1
     git reset --hard a2ce30b797882ffdbc3660edbfa5507dd23619ee || exit 1
     cd ../.. || exit 1
    sleep "$SLEEP"
  fi
done

echo "Failed after $RETRIES attempts" >&2
exit 1