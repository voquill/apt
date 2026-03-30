#!/bin/bash
set -euo pipefail

REPO_URL="https://voquill.github.io/apt"
KEYRING_PATH="/usr/share/keyrings/voquill.gpg"
TRUSTED_PATH="/etc/apt/trusted.gpg.d/voquill.gpg"
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

if ! command -v curl &>/dev/null; then
  echo "Error: curl not found. Please install curl first: sudo apt-get install curl"
  exit 1
fi

echo "Adding Voquill APT repository (${CHANNEL} channel)..."

sudo mkdir -p /usr/share/keyrings /etc/apt/trusted.gpg.d

curl -fsSL "${REPO_URL}/gpg-key.asc" -o /tmp/voquill-gpg-key.asc

if [[ ! -s /tmp/voquill-gpg-key.asc ]]; then
  echo "Error: Failed to download the GPG signing key." >&2
  echo "Please check your network connection and try again." >&2
  exit 1
fi

sudo gpg --batch --yes --dearmor -o "${KEYRING_PATH}" < /tmp/voquill-gpg-key.asc

if [[ ! -s "${KEYRING_PATH}" ]]; then
  echo "Error: Failed to install the GPG signing key." >&2
  exit 1
fi

sudo cp "${KEYRING_PATH}" "${TRUSTED_PATH}"
rm -f /tmp/voquill-gpg-key.asc

echo "deb [signed-by=${KEYRING_PATH} arch=amd64] ${REPO_URL} ${CHANNEL} main" \
  | sudo tee "${LIST_PATH}" > /dev/null

sudo apt-get update
sudo apt-get install -y "${PACKAGE}"

echo "Voquill has been installed successfully!"
