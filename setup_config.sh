#!/bin/bash

# MagicMirror Configuration Setup Script
# =====================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"
CONFIG_FILE="$MAGICMIRROR_DIR/config/config.js"

echo "⚙️  Setting up MagicMirror configuration..."

# Check if config already exists
if [ -f "$CONFIG_FILE" ]; then
    echo "📋 Configuration file already exists: $CONFIG_FILE"
    read -p "🔄 Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "✅ Keeping existing configuration"
        exit 0
    fi
fi

# Create config directory if it doesn't exist
mkdir -p "$MAGICMIRROR_DIR/config"

echo "📝 Configuration file will be created with:"
echo "   🌍 Location: Berhampur, Odisha, India"
echo "   🌤️  Weather: Local weather data"
echo "   📰 News: Indian news sources"
echo "   🕐 Time: Indian Standard Time"
echo "   📷 Camera: HD feed with face detection"
echo "   🤖 AI Assistant: Voice interaction"

# API Key setup
echo ""
echo "🔑 API Key Setup (Optional but Recommended)"
echo "   The system works with fallback responses, but for full AI features:"
echo "   1. Visit: https://makersuite.google.com/app/apikey"
echo "   2. Create a free Google "
echo "   3. Enter it below (or press Enter to skip)"
echo ""
read -p "🔐 Enter your Google Gemini API key (optional): " API_KEY

if [ -n "$API_KEY" ]; then
    echo "✅ API key will be configured"
    # Update the assistant bridge with the new API key
    sed -i "s/api_key = 'YOUR_API_KEY_HERE'/api_key = '$API_KEY'/" "$MAGICMIRROR_DIR/assistant_bridge_simple.py"
    echo "🔄 API key updated in assistant bridge"
else
    echo "⚠️  No API key provided. Using fallback AI responses."
    echo "💡 You can add an API key later by editing: assistant_bridge_simple.py"
fi

echo ""
echo "✅ Configuration setup complete!"
echo "🚀 You can now start MagicMirror with: ./start_magicmirror.sh"
