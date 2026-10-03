#!/bin/bash
# sysinfo.sh - prints OS information and resource usage
# usage: sudo ./sysinfo.sh

# convert bytes to a readable size (KiB / MiB / GiB) like free -h but with the "iB" suffix
hr() {
  awk -v b="$1" 'BEGIN{
    if (b >= 1073741824)      printf "%.1f GiB", b/1073741824;
    else if (b >= 1048576)    printf "%.0f MiB", b/1048576;
    else                      printf "%.1f KiB", b/1024;
  }'
}

# public ip needs internet - show N/A if the request fails or does not return an IP
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me)
[[ "$PUBLIC_IP" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || PUBLIC_IP="N/A"

# virtualization type (oracle = VirtualBox)
VIRT=$(systemd-detect-virt 2>/dev/null)
[ -z "$VIRT" ] || [ "$VIRT" == "none" ] && VIRT="Physical"

# timezone
TZ_NAME=$(timedatectl show -p Timezone --value 2>/dev/null)
[ -z "$TZ_NAME" ] && TZ_NAME=$(cat /etc/timezone 2>/dev/null)
[ -z "$TZ_NAME" ] && TZ_NAME="N/A"

# memory values in bytes
MEM_TOTAL=$(free -b | awk '/Mem:/  {print $2}')
MEM_USED=$(free -b  | awk '/Mem:/  {print $3}')
SWAP_TOTAL=$(free -b | awk '/Swap:/ {print $2}')
SWAP_USED=$(free -b  | awk '/Swap:/ {print $3}')

echo "System Information"
echo "  • Executed By: $(whoami)"
echo "  • Hostname: $(hostname)"
echo "  • Server IP: $(hostname -I | awk '{print $1}')"
echo "  • Public IP: $PUBLIC_IP"
echo "  • OS Type and Version: $(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)"
echo "  • Kernel Version: $(uname -r)"
echo "  • Architecture: $(uname -m)"
echo "  • Virtualization: ${VIRT^}"
echo "  • Server Time: $(date)"
echo "  • Timezone: $TZ_NAME ($(date +%Z))"
echo "  • Uptime: $(uptime -p | sed 's/^up //')"
echo ""
echo "Resource Usage"
echo "  • Total Memory: $(hr $MEM_TOTAL)"
echo "  • Memory Usage: $(hr $MEM_USED) / $(hr $MEM_TOTAL)"
echo "  • Swap Usage: $(hr $SWAP_USED) / $(hr $SWAP_TOTAL)"
echo "  • CPU Cores: $(nproc)"
