#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
if [[ $EUID -eq 0 ]]; then
    echo 'Run as your normal desktop user, without sudo. The script requests sudo where needed.' >&2
    exit 1
fi
if [[ $(uname -s) != Linux ]]; then echo 'This installer needs Raspberry Pi OS / Debian Linux.' >&2; exit 1; fi
sudo apt-get update
sudo apt-get install -y build-essential cmake git pkg-config libusb-1.0-0-dev python3-venv python3-numpy python3-scipy python3-aiohttp
# Keep distro scientific Python packages: avoid compiling SciPy on the Pi.
python3 -m venv --system-site-packages .venv
.venv/bin/python -c 'import numpy, scipy; from aiohttp import web; assert hasattr(web, "AppKey"), "aiohttp is too old; use Raspberry Pi OS Bookworm or newer"'
mkdir -p .driver-source
if [[ ! -d .driver-source/rtl-sdr-blog ]]; then
    git clone --depth 1 https://github.com/rtlsdrblog/rtl-sdr-blog.git .driver-source/rtl-sdr-blog
fi
cmake -S .driver-source/rtl-sdr-blog -B .driver-source/rtl-sdr-blog/build -DCMAKE_INSTALL_PREFIX=/usr/local -DINSTALL_UDEV_RULES=ON
cmake --build .driver-source/rtl-sdr-blog/build --parallel 2
sudo cmake --install .driver-source/rtl-sdr-blog/build
sudo ldconfig
sudo install -m 644 .driver-source/rtl-sdr-blog/rtl-sdr.rules /etc/udev/rules.d/20-hamtec-rtl-sdr.rules
printf '%s\n' 'blacklist dvb_usb_rtl28xxu' | sudo tee /etc/modprobe.d/hamtec-rtl-sdr.conf >/dev/null
sudo udevadm control --reload-rules
chmod +x START-RASPBERRY-PI.sh
printf '\nInstallation complete. Reboot the Pi, plug in the RTL-SDR, then run:\nbash START-RASPBERRY-PI.sh\n'
