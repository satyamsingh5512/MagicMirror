#!/bin/bash

# AI Assistant Test Script
# ========================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"
PYTHON_ENV="$MAGICMIRROR_DIR/assistant_env/bin/python"

echo "🤖 Testing AI Assistant..."

if [ ! -f "$PYTHON_ENV" ]; then
    echo "❌ Python environment not found: $PYTHON_ENV"
    echo "💡 Run the installation script first: ./install.sh"
    exit 1
fi

cd "$MAGICMIRROR_DIR"

echo "🎯 Running assistant in interactive mode..."
echo "💬 Type your questions and press Enter"
echo "🚪 Type 'quit' to exit"

"$PYTHON_ENV" assistant_bridge_simple.py interactive
