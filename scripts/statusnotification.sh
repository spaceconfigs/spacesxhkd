#!/bin/bash

# Initialize variables to store which data will be shown
show_date_time=false
show_volume=false
show_ram_usage=false
show_disk_usage=false
show_cpu_usage=false
show_cpu_temperature=false
show_gpu_temperature=false

# Check if a title was provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 \"title\" [--date] [--cpu] [--ram] [--disk] [--volume] [--gpu] [--all]"
  exit 1
fi

# The first argument is the title
title="$1"
shift # Shift the arguments so the remaining ones are flags

# Use getopt to handle long options including --all
OPTIONS=$(getopt -o "" \
    --long date,cpu,ram,disk,volume,gpu,all \
    -- "$@")

# If getopt fails (invalid options), exit with an error
if [ $? -ne 0 ]; then
  echo "Usage: $0 \"title\" [--date] [--cpu] [--ram] [--disk] [--volume] [--gpu] [--all]"
  exit 1
fi

# Evaluate the parsed options
eval set -- "$OPTIONS"

# Parse the options
while true; do
  case "$1" in
    --date)
      show_date_time=true
      shift
      ;;
    --cpu)
      show_cpu_usage=true
      shift
      ;;
    --ram)
      show_ram_usage=true
      shift
      ;;
    --disk)
      show_disk_usage=true
      shift
      ;;
    --volume)
      show_volume=true
      shift
      ;;
    --gpu)
      show_gpu_temperature=true
      shift
      ;;
    --all)
      show_date_time=true
      show_volume=true
      show_ram_usage=true
      show_disk_usage=true
      show_cpu_usage=true
      show_cpu_temperature=true
      show_gpu_temperature=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Usage: $0 \"title\" [--date] [--cpu] [--ram] [--disk] [--volume] [--gpu] [--all]"
      exit 1
      ;;
  esac
done

# Fetch system data
date_time=$(date +"%d (%A) %B %H:%M")
volume=$(amixer get Master | grep -oP '[0-9]+(?=%)' | head -n 1)
ram_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
disk_usage=$(df / | tail -1 | awk '{print $5}')
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_temperature=$(sensors | grep -E 'Tctl|Composite|temp1' | awk '{print $2}' | sed 's/+//g' | head -n 1)
gpu_temperature=$(sensors | grep -E 'edge|temp1' | awk '{print $2}' | sed 's/+//g' | head -n 1)

# Construct the message based on options
message=""

if [ "$show_date_time" = true ]; then
  message+="$date_time\n"
fi

if [ "$show_volume" = true ]; then
  message+="Volume: $volume%\n"
fi

if [ "$show_cpu_usage" = true ]; then
  message+="CPU usage: ${cpu_usage}%\n"
fi

if [ "$show_cpu_temperature" = true ]; then
  message+="CPU temperature: ${cpu_temperature}°C\n"
fi

if [ "$show_gpu_temperature" = true ]; then
  message+="GPU temperature: ${gpu_temperature}°C\n"
fi

if [ "$show_ram_usage" = true ]; then
  message+="RAM: ${ram_usage}%\n"
fi

if [ "$show_disk_usage" = true ]; then
  message+="Disk: $disk_usage\n"
fi

# Send the notification only if there is something to show
if [ -n "$message" ]; then
  notify-send "$title" "$message"
else
  echo "No information to display. Use options to select what to show."
  exit 1
fi

