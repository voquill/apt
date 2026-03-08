#!/bin/bash
set -euo pipefail

REPO_URL="https://voquill.github.io/voquill-apt"
KEYRING_PATH="/usr/share/keyrings/voquill.gpg"
LIST_PATH="/etc/apt/sources.list.d/voquill.list"

if ! command -v apt-get &>/dev/null; then
  echo "Error: apt-get not found. This script supports Debian/Ubuntu-based systems only."
  echo "Download Voquill from https://voquill.com/download"
  exit 1
fi

echo "Adding Voquill APT repository..."

# Add GPG key
curl -fsSL "${REPO_URL}/gpg-key.asc" | sudo gpg --dearmor -o "${KEYRING_PATH}"

# Add repository
echo "deb [signed-by=${KEYRING_PATH} arch=amd64] ${REPO_URL} stable main" \
  | sudo tee "${LIST_PATH}" > /dev/null

# Install
sudo apt-get update
sudo apt-get install -y voquill-desktop

echo "Voquill has been installed successfully!"
echo "Run 'voquill' to get started."
