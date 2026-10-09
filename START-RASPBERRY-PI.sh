#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
if [[ ! -x .venv/bin/python ]]; then echo 'Run bash INSTALL-RASPBERRY-PI.sh first.' >&2; exit 1; fi
# Limit numerical-library threads so DSP and the browser share the Pi's CPU.
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1
export LD_LIBRARY_PATH="/usr/local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec .venv/bin/python hamtec_usb_audio.py "$@"
