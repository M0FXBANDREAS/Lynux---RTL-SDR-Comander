HamTech RTL Commander — Raspberry Pi 4 USB edition

Recommended: Raspberry Pi OS Desktop 64-bit (Bookworm or newer), monitor,
keyboard/mouse, internet for installation, and an RTL-SDR plugged into a Pi USB
port. No rtl_tcp server is required. Run the browser and receiver on the Pi.
The software retains the original LSB/USB/CW/AM/NFM/WFM controls and 25 kHz NFM
filter option. Broadcast FM audio is mono.

SETUP
1. Extract this ZIP into your home folder. Open a terminal in the extracted
   HamTech-RTL-Comander folder.
2. Run:
      bash INSTALL-RASPBERRY-PI.sh
   Run as your regular user. Enter your password for the sudo steps if asked.
   The installer builds the RTL-SDR Blog Linux driver under /usr/local,
   installs USB access rules, and disables the conflicting DVB kernel driver
   at the next boot. It uses Raspberry Pi OS Python packages in a virtual env.
   It does not remove existing system RTL-SDR packages. It will replace any
   existing RTL-SDR driver previously installed under /usr/local.
3. Reboot:
      sudo reboot
4. Plug the RTL-SDR into USB, attach an appropriate antenna, and run:
      bash START-RASPBERRY-PI.sh
5. In Chromium on the Pi, open:
      http://127.0.0.1:8765
   Press POWER. Select your mode and frequency. Choose the Pi's HDMI,
   headphone, or USB audio output using the desktop sound settings.
   Audio comes from the browser's selected output, not the dongle.
6. Stop with Ctrl+C in the terminal. Use only one receiver browser tab.

DRIVER / HARDWARE NOTES
The installer uses https://github.com/rtlsdrblog/rtl-sdr-blog for Blog V4
support. Driver reference: https://www.rtl-sdr.com/V4/
No Windows DLL or Zadig driver is used on Raspberry Pi.
The receiver starts at 4.006934 MHz LSB, matching the original project.
Blog V4 HF requires the correct driver. Ordinary tuner-only RTL-SDR models
cannot receive this HF frequency; tune a supported VHF/UHF frequency instead.
The Blog driver can auto-select direct sampling on supported V3 models.
V4 recognition in SYSTEM STATUS identifies the device; successful HF reception
still depends on the driver, antenna and signal. Use a proper Pi power supply.

TROUBLESHOOTING
- No USB device: run lsusb; check the dongle and cable.
- Busy or inaccessible: close other SDR apps, rtl_tcp and rtl_test. Reboot
  after installation and reconnect the dongle to apply USB permissions.
- Driver test, with the app STOPPED:
      /usr/local/bin/rtl_test -s 1024000
  Stop with Ctrl+C before starting the app. Some dropped samples at startup
  can occur; continuous loss needs investigation.
- Silent audio: press POWER, check volume/mute, select the correct desktop
  audio output, and open the localhost address in Chromium on the Pi.
- Stuttering: close other apps, disable NR/NB/ANF, check Pi temperature,
  power and CPU load. USB capture drops are shown in SYSTEM STATUS.
- No desktop / using SSH: run with --no-browser and use an SSH tunnel from
  your desktop computer:
      ssh -L 8765:127.0.0.1:8765 YOUR_USER@YOUR_PI_IP
  Run on the Pi: bash START-RASPBERRY-PI.sh --no-browser
  Open http://127.0.0.1:8765 on the computer; audio plays on that computer.
  Direct access through the Pi's LAN IP is not enabled. Localhost is also
  needed for the browser AudioWorklet secure-context requirement.
- Missing Python modules: rerun the installer. Do not run the receiver as root.
- Port 8765 occupied: stop the previous receiver instance.
- To select an alternate compatible Linux library, set:
      export HAMTEC_RTLSDR_LIBRARY=/absolute/path/to/librtlsdr.so

VALIDATION AND LIMITS
Python compile checks, shell syntax checks, synthetic DSP in all six modes,
mocked Linux USB driver/capture tests, and local HTTP/WebSocket tests were run
in the build environment. Actual Pi 4 CPU performance, USB reception and
speaker output have not been tested here. This package needs a first hardware
check on your Pi. The installer needs access to Raspberry Pi OS package
servers and GitHub. No driver binary is bundled; it is built for your Pi.
The Windows files and original README-FIRST.txt remain for reference; use
THIS README and the .sh scripts for Raspberry Pi.
