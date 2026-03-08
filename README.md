# ESPhome SmallTV Ultra

ESPhome configuration for the [GeekMagic SmallTV](https://h5.clewm.net/?url=qr61.cn%2FonQs0U%2FqlPEzlA&lid=3t9uj0vibygtblt0o&rlid=8lp7v63u7uwtbf9gz) — a tiny 240×240 display clock powered by an ESP8266.

---

## Hardware

| Component | Detail |
|-----------|--------|
| MCU | ESP-12F (ESP8266) |
| Display | 240×240 ST7789v (SPI, no CS pin) |
| Backlight | PWM via GPIO5 |
| SPI CLK | GPIO14 |
| SPI MOSI | GPIO13 |
| DC pin | GPIO0 |
| Reset pin | GPIO2 |

---

## Flashing ESPhome

The device ships with vendor firmware. To flash ESPhome you need to open it and connect a USB-UART adapter to the ESP8266 pads. Community guides:

- **Forum thread (setup + pinouts):** [Installing ESPhome on GeekMagic SmallTV Pro — Home Assistant Community](https://community.home-assistant.io/t/installing-esphome-on-geekmagic-smart-weather-clock-smalltv-pro/618029)
- **Later pages with tips & tricks:** [Page 8 of the same thread](https://community.home-assistant.io/t/installing-esphome-on-geekmagic-smart-weather-clock-smalltv-pro/618029/216?page=8)
- **Video walkthrough:** [YouTube — SmallTV ESPhome flash guide](https://www.youtube.com/watch?v=S1Q9PZ95SDM)

---

## Features

### Clock display
- Large digit clock using the **Orbitron** Google Font at size 100
- Hours and minutes separated by a thin divider line
- Burn-in protection: display position shifts by 1px every minute

### Rain mode (default)
- 10 animated 💧 raindrops fall down the screen at varying speeds
- Each raindrop resets at the top with a random X position after reaching the bottom
- Clock is drawn on top of the rain

### Night mode
- Deep night-blue background
- 20 static stars scattered across the screen
- Crescent moon in the upper-left corner (warm yellow-white)
- Shooting star that streaks diagonally across the screen with a glowing tail, then respawns

---

## Home Assistant controls

After adopting the device in Home Assistant, you get:

| Entity | Type | Description |
|--------|------|-------------|
| `light.mini_display_clock_backlight` | Light | Backlight brightness (dimmable) |
| `switch.night_mode` | Switch | Toggle between Rain and Night mode |

Toggle **Night Mode** on at sunset via an automation, or add it to a dashboard card.

### Example automation (Lovelace)

```yaml
automation:
  - alias: "SmallTV Night Mode at sunset"
    trigger:
      - platform: sun
        event: sunset
    action:
      - service: switch.turn_on
        target:
          entity_id: switch.night_mode
  - alias: "SmallTV Rain Mode at sunrise"
    trigger:
      - platform: sun
        event: sunrise
    action:
      - service: switch.turn_off
        target:
          entity_id: switch.night_mode
```

---

## Adding more animations

The display lambda branches on `id(night_mode)`. To add new modes (e.g. rocket ship, weather icons), extend with additional globals and a mode integer instead of a bool. All drawing is done with ESPhome's built-in primitives:

- `it.filled_circle(cx, cy, r, color)` — solid circle
- `it.filled_rectangle(x, y, w, h, color)` — solid rectangle
- `it.line(x1, y1, x2, y2, color)` — line
- `it.printf(x, y, font, color, align, fmt, ...)` — text / emoji

---

## Quick start

### 1. Create `secrets.yaml`

Create this file alongside `ultratv.yaml` (it is gitignored — your credentials will not be committed):

```yaml
wifi_ssid: "YourNetworkName"
wifi_password: "YourPassword"
```

### 2. Set your timezone

Edit `ultratv.yaml` and update the `timezone:` field under `time:`. Find your timezone string in the [tz database list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

### 3. Deploy

**Option A — local CLI (recommended for iteration):**

```bash
# One-time setup
python3 -m venv ~/.venvs/esphome
source ~/.venvs/esphome/bin/activate
pip install esphome

# Compile + OTA push in one step
./deploy.sh
```

`deploy.sh` discovers the device via mDNS (`geekmagic.local`) automatically. No need to touch the HA addon.

**Option B — Home Assistant ESPhome addon:**

Open the ESPhome addon dashboard, click **Install** on the `geekmagic` device. It compiles and pushes OTA. Alternatively, download the compiled `.bin` and upload it at `http://geekmagic.local/update`.

### 4. Adopt in Home Assistant

After flashing, Home Assistant will discover the device automatically. Accept the adoption prompt to get the `Backlight` light and `Night Mode` switch entities.
