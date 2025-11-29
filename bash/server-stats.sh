#!/bin/bash

# This script collects and displays server statistics such as CPU usage,
# memory usage, disk usage, and network activity.

# --- Configuration ---
TOP_PROCESSES=5 

echo "==============================="
echo "   SERVER PERFORMANCE STATS    "
echo "===============================" 
echo "Report generated on: $(date)"
echo "-------------------------------"

# General System Information
echo -e "\n### 🖥️ General System Information ###"
echo "OS Version: $(cat /etc/os-release | grep "PRETTY_NAME" | cut -d= -f2 | tr -d '"')"
echo "Uptime: $(uptime -p)"
echo "-----------------------"

# Total CPU isage
echo -e "\n### 📈 Total CPU Usage ###"
CPU_IDLE=$(vmstat -t 1 2 | tail -1 | awk '{print $15}')
CPU_USED=$((100 - CPU_IDLE))
echo "CPU Idle: ${CPU_IDLE}%"
echo "CPU USED: ${CPU_USED}%"
echo "-----------------------"


# Total Memory Usage
echo -e "\n### 🧠 Total Memory Usage ###"
free -m | awk '/^Mem:/ {
    total=$2; used=$3; free=$4;
    used_percent=(used/total)*100;
    free_percent=(free/total)*100;
    printf "Total: %d MB\n", total;
    printf "Used: %d MB (%.2f%%)\n", used, used_percent;
    printf "Free: %d MB (%.2f%%)\n", free, free_percent;
}'
echo "-----------------------"

# Total Disk Usage
echo -e "\n### 💾 Total Disk Usage ###"
df -h | grep -E 'ext|xfs|rootfs' | awk '{
    print "Filesystem:" $1;
    print "Total: " $2;
    print "Used: " $3 " ("$5")";
    print "Free: " $4 " (" 100 - substr($5, 1, length($5)-1) "%)";
    print "Mount: " $6;
}'
echo "-----------------------"

# Top Processes by CPU Usage
echo -e "\n### 🔥 Top ${TOP_PROCESSES} Processes by CPU Usage ###"
ps -eo user,pid,%cpu,%mem,command --sort=-%cpu | head -n $((TOP_PROCESSES + 1))

# Top 5 Processes by Memory Usage
echo -e "\n### 🧠 Top ${TOP_PROCESSES} Processes by Memory Usage ###"
ps -eo user,pid,%cpu,%mem,command --sort=-%mem | head -n $((TOP_PROCESSES + 1))

echo "=========================================="