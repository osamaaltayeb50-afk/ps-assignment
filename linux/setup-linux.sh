#!/bin/bash
# setup-linux.sh - Linux section of the assignment (Ubuntu 24.04)
# usage: sudo ./setup-linux.sh
# Passwords are NOT in this script: run "sudo passwd PS" and "sudo passwd root" yourself.
set -e

echo "== 2) user PS with primary group PSgroup and secondary group dba =="
getent group PSgroup >/dev/null || groupadd PSgroup
getent group dba     >/dev/null || groupadd dba
id PS &>/dev/null || useradd -m -s /bin/bash -g PSgroup -G dba PS
id PS

echo "== 4) install MySQL and HAProxy =="
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y mysql-server haproxy
systemctl enable --now mysql haproxy
systemctl --no-pager status mysql   | head -n 5
systemctl --no-pager status haproxy | head -n 5
mysql --version
haproxy -v | head -n 1
