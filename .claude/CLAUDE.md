# ESPHome SmallTV Ultra

## Before every firmware change
- Run `/nobrick` to verify safety-critical settings (OTA, captive_portal, GPIO pins, board, display model).
- After editing YAML, run `esphome config ultratv.yaml` to validate — do not rely on memory alone for schema correctness.

## When editing YAML
- Fetch the relevant component page from `https://esphome.io/components/<name>.html` before making config changes. The schema changes across versions and guessing keys/locations will cause failed builds.
- Key components: wifi, display, i2c, spi, font, light, sensor, text_sensor, select, switch, globals, interval, captive_portal, web_server, ota, api, template.

## Project structure
- `ultratv.yaml` — main firmware configuration
- `secrets.yaml` — WiFi credentials (gitignored)
- `deploy.sh` — validates config then OTA-flashes to `geekmagic.local`
- `ultratv_backup.yaml` — last known good backup

## Device
- Board: ESP01_1m (1MB flash, no OTA partition — single firmware)
- Display: ST7789V 240x240 via mipi_spi
- ESPHome version: 2026.2.4
- Hostname: geekmagic.local
