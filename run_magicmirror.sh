#!/bin/bash

# MagicMirror Startup Script
# This script ensures all dependencies are installed and starts MagicMirror

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$SCRIPT_DIR/MagicMirror"

echo "========================================="
echo "  MagicMirror Startup Script"
echo "========================================="
echo ""

# Check if MagicMirror directory exists
if [ ! -d "$MAGICMIRROR_DIR" ]; then
    echo "❌ Error: MagicMirror directory not found!"
    exit 1
fi

cd "$MAGICMIRROR_DIR"

# Check if config exists
if [ ! -f "config/config.js" ]; then
    echo "⚠️  No config file found. Creating from sample..."
    cp config/config.js.sample config/config.js
    echo "✅ Config file created. Please edit config/config.js before running again."
    exit 0
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install --no-audit --no-fund --no-update-notifier
fi

# Check Node version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "⚠️  Warning: Node.js version 18 or higher is recommended"
fi

echo ""
echo "✅ All checks passed!"
echo ""
echo "🚀 Starting MagicMirror..."
echo "   Press Ctrl+C to stop"
echo ""

# Start MagicMirror
npm start
