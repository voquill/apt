#!/bin/bash
set -euo pipefail

REPO_URL="https://voquill.github.io/apt"
KEYRING_PATH="/usr/share/keyrings/voquill.gpg"
LIST_PATH="/etc/apt/sources.list.d/voquill.list"
CHANNEL="stable"
PACKAGE="voquill-desktop"

for arg in "$@"; do
  case "$arg" in
    --dev)
      CHANNEL="dev"
      PACKAGE="voquill-desktop-dev"
      ;;
  esac
done

if ! command -v apt-get &>/dev/null; then
  echo "Error: apt-get not found. This script supports Debian/Ubuntu-based systems only."
  echo "Download Voquill from https://voquill.com/download"
  exit 1
fi

echo "Adding Voquill APT repository (${CHANNEL} channel)..."

curl -fsSL "${REPO_URL}/gpg-key.asc" | sudo gpg --batch --yes --dearmor -o "${KEYRING_PATH}"

echo "deb [signed-by=${KEYRING_PATH} arch=amd64] ${REPO_URL} ${CHANNEL} main" \
  | sudo tee "${LIST_PATH}" > /dev/null

sudo apt-get update
sudo apt-get install -y "${PACKAGE}"

echo "Voquill has been installed successfully!"
