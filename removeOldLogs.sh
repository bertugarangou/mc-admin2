#!/bin/bash
LOG_DIR="/home/minecraft/server/logs"
find "$LOG_DIR" -name '*.log.gz' -type f -mtime +5 -exec rm {} \;
