#!/bin/bash

# MagicMirror AI Assistant Startup Script
# =======================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"

echo "🪞 Starting MagicMirror AI Assistant..."
echo "📁 Project Directory: $PROJECT_DIR"
echo "🏠 MagicMirror Directory: $MAGICMIRROR_DIR"

# Check if MagicMirror directory exists
if [ ! -d "$MAGICMIRROR_DIR" ]; then
    echo "❌ MagicMirror directory not found: $MAGICMIRROR_DIR"
    exit 1
fi

# Change to MagicMirror directory
cd "$MAGICMIRROR_DIR"

# Check if config exists
if [ ! -f "config/config.js" ]; then
    echo "❌ Configuration file not found: config/config.js"
    echo "💡 Run the setup script first: ./setup_config.sh"
    exit 1
fi

# Start MagicMirror
echo "🚀 Starting MagicMirror..."
npm start
