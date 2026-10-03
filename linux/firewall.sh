#!/bin/bash
# firewall.sh - allow TCP/UDP only on port 3306 (ufw)
# IMPORTANT: this also blocks SSH (port 22). Run it last, after the file copy step,
# and keep the VirtualBox console open.
set -e
apt-get install -y ufw
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 3306/tcp
ufw allow 3306/udp
ufw --force enable
ufw status verbose
