#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "This script must be run as root. Try: sudo $0" >&2
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script is intended for Debian/Ubuntu systems (apt-get not found)." >&2
  exit 1
fi

echo "[*] Updating package lists (apt-get update)..."
apt-get update

echo "[*] Upgrading packages (apt-get -y upgrade)..."
export DEBIAN_FRONTEND=noninteractive
apt-get -y upgrade

# Uncomment these lines if you also want dist-upgrade:
# echo "[*] Performing dist-upgrade (apt-get -y dist-upgrade)..."
# apt-get -y dist-upgrade

if ! commandv_tailscale="$(command -v tailscale 2>/dev/null)"; then
  cat >&2 <<'EOF'
[!] tailscale is not installed or not in PATH.
    Install tailscale first, for example:

      curl -fsSL https://tailscale.com/install.sh | sh

    Then re-run this script.
EOF
  exit 1
fi

echo "[*] Ensuring tailscaled service is enabled and running..."
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now tailscaled || {
    echo "[!] Failed to enable/start tailscaled via systemctl. Continuing, but Tailscale may not start on boot." >&2
  }
else
  echo "[!] systemctl not found; cannot manage tailscaled service automatically. Ensure tailscaled runs on boot." >&2
fi

echo "[*] Checking Tailscale status..."
if "$commandv_tailscale" status >/dev/null 2>&1; then
  echo "[*] Tailscale is authenticated. Ensuring Tailscale is up with SSH..."
  if ! "$commandv_tailscale" up --ssh; then
    cat >&2 <<'EOF'
[!] 'tailscale up --ssh' did not complete successfully.
    You may need to re-authenticate this machine:

      sudo tailscale up --ssh
EOF
  else
    echo "[*] Tailscale is up with SSH enabled. This setting is persistent across reboots."
  fi
else
  cat >&2 <<'EOF'
[!] This machine is not currently authenticated to your Tailscale tailnet.
    After the reboot, run:

      sudo tailscale up --ssh

    to authenticate and enable Tailscale SSH.
EOF
fi

echo
echo "[*] System will reboot in 10 seconds. Press Ctrl+C now to cancel if needed."
sleep 10

if command -v systemctl >/dev/null 2>&1; then
  echo "[*] Rebooting via systemctl reboot..."
  exec systemctl reboot
else
  echo "[*] Rebooting via 'reboot'..."
  exec reboot
fi

