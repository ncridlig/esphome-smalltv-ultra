#!/usr/bin/env bash
# deploy.sh — compile and OTA-push ultratv.yaml to geekmagic.local
#
# One-time setup:
#   python3 -m venv ~/.venvs/esphome
#   source ~/.venvs/esphome/bin/activate
#   pip install esphome
#
# Usage:
#   ./deploy.sh

set -e

VENV="$HOME/.venvs/esphome"
YAML="$(dirname "$0")/ultratv.yaml"

if [ ! -f "$VENV/bin/activate" ]; then
  echo "ESPhome venv not found. Setting it up..."
  python3 -m venv "$VENV"
  source "$VENV/bin/activate"
  pip install --quiet esphome
else
  source "$VENV/bin/activate"
fi

# secrets.yaml must live alongside ultratv.yaml
SECRETS="$(dirname "$0")/secrets.yaml"
if [ ! -f "$SECRETS" ]; then
  echo ""
  echo "ERROR: secrets.yaml not found at $SECRETS"
  echo "Create it with:"
  echo "  wifi_ssid: \"YourNetwork\""
  echo "  wifi_password: \"YourPassword\""
  echo ""
  exit 1
fi

echo "Validating config..."
if ! esphome config "$YAML" > /dev/null; then
  echo ""
  echo "Config validation failed. Fix the errors above before flashing."
  exit 1
fi

echo "Compiling and pushing to geekmagic.local ..."
esphome run "$YAML"
