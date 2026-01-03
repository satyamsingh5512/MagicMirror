#!/bin/bash

# Script to switch between configurations

MAGICMIRROR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/MagicMirror"
CONFIG_DIR="$MAGICMIRROR_DIR/config"

echo "========================================="
echo "  MagicMirror Configuration Switcher"
echo "========================================="
echo ""

if [ ! -d "$CONFIG_DIR" ]; then
    echo "❌ Error: Config directory not found!"
    exit 1
fi

cd "$CONFIG_DIR"

echo "Available configurations:"
echo ""
echo "1) config_pi3b.js    - Optimized for Raspberry Pi 3B (Recommended)"
echo "2) config.js.sample  - Standard configuration"
echo "3) Keep current      - Don't change"
echo ""

read -p "Select configuration (1-3): " choice

case $choice in
    1)
        if [ -f "config.js" ]; then
            cp config.js config.js.backup
            echo "✅ Current config backed up to config.js.backup"
        fi
        cp config_pi3b.js config.js
        echo "✅ Switched to Raspberry Pi 3B optimized configuration"
        echo ""
        echo "This configuration includes:"
        echo "  - 5 modules (reduced for performance)"
        echo "  - Disabled animations"
        echo "  - Longer update intervals"
        echo "  - Network accessible (0.0.0.0)"
        ;;
    2)
        if [ -f "config.js" ]; then
            cp config.js config.js.backup
            echo "✅ Current config backed up to config.js.backup"
        fi
        cp config.js.sample config.js
        echo "✅ Switched to standard configuration"
        echo "⚠️  Note: You'll need to customize this config"
        ;;
    3)
        echo "✅ Keeping current configuration"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Current configuration: $CONFIG_DIR/config.js"
echo ""
