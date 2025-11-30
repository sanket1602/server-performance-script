#!/bin/bash

echo 
echo 
echo "Server Performance Stats"
echo
echo


echo ">> OS Version:"
if [ -f /etc/os-release ]; then
    grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"'
else
    uname -a
fi
echo


echo ">> Uptime & Load Average:"
uptime
echo


echo ">> Total CPU Usage:"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo "CPU Usage: $CPU_USAGE%"
echo


echo ">> Memory Usage:"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_PERC=$(( MEM_USED * 100 / MEM_TOTAL ))

echo "Total Memory : ${MEM_TOTAL} MB"
echo "Used Memory  : ${MEM_USED} MB"
echo "Free Memory  : ${MEM_FREE} MB"
echo "Memory Usage : ${MEM_PERC}%"
echo


echo ">> Disk Usage (root partition):"
df -h / | awk 'NR==2{print "Total Disk: "$2"\nUsed Disk : "$3"\nFree Disk : "$4"\nUsage     : "$5}'
echo


echo ">> Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo


echo ">> Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo


echo ">> Logged-in Users:"
who
echo

echo ">> Failed Login Attempts (lastb):"
if command -v lastb >/dev/null 2>&1; then
    lastb | head
else
    echo "lastb command not available on this system."
fi
echo

echo 
echo "End Of Report"
echo 
