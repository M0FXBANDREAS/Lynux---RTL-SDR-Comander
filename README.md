[HamTech-RTL-Commander-Raspberry-Pi4.zip](https://github.com/user-attachments/files/33257641/HamTech-RTL-Commander-Raspberry-Pi4.zip)
# Lynux---RTL-SDR-Comander
SDR Comander 
# HamTech RTL Commander — Raspberry Pi 4 Edition

A browser-based RTL-SDR receiver for Raspberry Pi 4, with live spectrum, waterfall display and receiver audio.

This edition adapts HamTech RTL Commander V17 for Linux, adds Raspberry Pi installation scripts and improves DSP processing efficiency.

## Features

- Direct USB reception with an RTL-SDR receiver.
- RTL-SDR Blog V4 driver support.
- LSB, USB, CW, AM, NFM and WFM modes.
- NFM filters up to 25 kHz.
- Live spectrum and waterfall display.
- 48 kHz browser audio.
- Frequency, RF gain, AGC, squelch and PPM controls.
- Noise blanker, noise reduction, automatic notch and manual notch controls.
- UK channel presets and frequency memories.
- Read-only HamQTH DX cluster integration.
- Customisable interface colours.

The RTL-SDR is receive-only. Transmit, power and SWR measurements are unavailable.

## Requirements

- Raspberry Pi 4.
- Raspberry Pi OS Desktop Bookworm or newer; 64-bit preferred.
- RTL-SDR Blog V4 USB receiver and a suitable antenna.
- Chromium browser.
- Internet access for installation and the optional DX cluster feed.
- Working audio output through HDMI, the headphone jack or USB audio.

Other RTL-SDR models may work on supported bands. HF reception depends on the receiver model, driver and antenna.

## Installation

Download and extract the project, then open a terminal in the folder containing `INSTALL-PI4.sh`.

Run the installer as your normal user:

```bash
bash INSTALL-PI4.sh
```

The installer uses `sudo` when needed to:

- Install system dependencies.
- Add USB access rules.

It also creates a Python virtual environment and builds the official RTL-SDR Blog driver into the project’s `driver/` folder. It does not replace system SDR libraries.

After installation, unplug and reconnect the RTL-SDR.

## Start the Receiver

```bash
bash START-PI4.sh
```

Open Chromium at:

```text
http://127.0.0.1:8765
```

Press **POWER** to enable receiver audio.

Keep the terminal open while using the receiver. Press **Ctrl+C** in the terminal to stop it.

Only one receiver tab can use the device at a time. Close other SDR applications before starting.

### Optional Startup Arguments

Start without opening a browser automatically:

```bash
bash START-PI4.sh --no-browser
```

Use a different port:

```bash
bash START-PI4.sh --port 8766
```

Then open `http://127.0.0.1:8766`.

## Audio Setup

Select the required output in Raspberry Pi OS sound settings, then check the browser and system volume.

Audio plays through the browser. Use **TEST SPEAKERS** in the receiver settings to check playback.

## Headless Operation

The receiver can run on Raspberry Pi OS Lite and stream audio to a browser on another computer through an SSH tunnel.

Start it on the Pi:

```bash
bash START-PI4.sh --no-browser
```

On your other computer, substitute your actual Pi username and address:

```bash
ssh -L 8765:127.0.0.1:8765 your-user@your-pi
```

Open Chromium or Chrome on that computer at:

```text
http://localhost:8765
```

Keep the SSH connection open. Audio plays on the computer running the browser.

The application listens on loopback and accepts localhost requests. Direct access using the Pi’s LAN IP address is not supported by this configuration.

## Troubleshooting

### Receiver Not Found or USB Busy

- Unplug and reconnect the receiver.
- Close `rtl_test`, `rtl_tcp` and other SDR applications.
- Rerun the installer if USB permissions are missing.
- Reboot if the DVB driver still holds the device.
- Run the receiver as your normal user, not with `sudo`.

### Missing Driver or Driver Symbol

Rerun:

```bash
bash INSTALL-PI4.sh
```

The application requires a V4-compatible Linux RTL-SDR driver.

### No Audio

- Press **POWER**.
- Use **TEST SPEAKERS**.
- Check system volume and the selected audio output.
- Open the interface in Chromium.

### Audio Breakups

Check **SYSTEM STATUS** for capture drops, USB queue growth and audio production rate. The PCM production rate should settle near 48,000 samples per second.

Try disabling NR, NB and ANF, closing other applications, and checking the Pi’s cooling and power supply.

### DX Cluster Unavailable

The HamQTH feed requires internet access. A feed failure does not stop USB reception or audio.

## Software Checks

After installation, run:

```bash
.venv/bin/python test_pi4.py
```

Hardware-free checks cover:

- Audio block size and finite output in all six modes.
- FIR filter continuity across block boundaries.
- Browser assets and WebSocket audio streaming.
- Retuning and disconnect/reconnect behaviour.
- Rejection of requests from a foreign origin.

The optimized DSP matched the original audio within the comparison test tolerance and measured approximately 22% faster on the development host.

These results are software checks, not Raspberry Pi benchmarks. Installation, USB reception and audio playback still require testing on actual Pi hardware.

## Driver Sources

- [RTL-SDR Blog driver repository](https://github.com/rtlsdrblog/rtl-sdr-blog)
- [RTL-SDR Blog V4 user guide](https://www.rtl-sdr.com/V4/)

The downloaded driver source and its licence are retained under `.build/rtl-sdr-blog` after installation.

## Additional Documentation

See `README-PI4.txt` for detailed setup instructions.

`README-ORIGINAL-WINDOWS.txt` contains the original feature notes. Its Windows installation instructions do not apply to this edition.
