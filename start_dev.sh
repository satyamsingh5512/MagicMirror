#!/bin/bash

# MagicMirror AI Assistant Development Startup Script
# ==================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"

echo "🪞 Starting MagicMirror AI Assistant (Development Mode)..."
cd "$MAGICMIRROR_DIR"
npm run start:dev
