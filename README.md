# Voquill APT Repository

APT package repository for [Voquill](https://voquill.com) desktop app.

## Quick Install

```bash
curl -fsSL https://voquill.github.io/voquill-desktop-apt/install.sh | bash
```

## Manual Setup

```bash
# Add GPG key
curl -fsSL https://voquill.github.io/voquill-desktop-apt/gpg-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/voquill.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/voquill.gpg arch=amd64] https://voquill.github.io/voquill-desktop-apt stable main" \
  | sudo tee /etc/apt/sources.list.d/voquill.list

# Install
sudo apt-get update
sudo apt-get install voquill-desktop
```

## Available Packages

- `voquill-desktop` — Stable release
- `voquill-desktop-dev` — Development release

## Upgrade

```bash
sudo apt-get update
sudo apt-get upgrade voquill-desktop
```
