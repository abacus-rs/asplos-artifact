#!/bin/bash
RETRIES=5
SLEEP=1
HELPER="./setup_redox_helper.sh"

if [[ ! -x "$HELPER" ]]; then
  echo "Helper not found or not executable: $HELPER" >&2
  exit 2
fi

for i in $(seq 1 $RETRIES); do
  echo "[setup_redox] Attempt $i/$RETRIES: running $HELPER"
  if "$HELPER"; then
    echo "[setup_redox] Success on attempt $i"
    exit 0
  fi
  echo "[setup_redox] Attempt $i failed"
  if [[ $i -lt $RETRIES ]]; then
    echo "[setup_redox] Retrying in ${SLEEP}s..."
    sleep "$SLEEP"
  fi
done

echo "[setup_redox] Failed after $RETRIES attempts" >&2
exit 1