#!/bin/bash
# Firefox launcher for Zonix OS
# Launches Firefox with Zonix-optimized settings

export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

# Check if Firefox is installed
if ! command -v firefox &> /dev/null; then
    echo "Firefox не найден. Установите его:"
    echo "  sudo apt install firefox"
    exit 1
fi

# Launch Firefox
firefox "$@" &

echo "Firefox запущен в фоновом режиме"
