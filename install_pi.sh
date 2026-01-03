#!/bin/bash

# MagicMirror Installation Script for Raspberry Pi 3B
# This script automates the installation process

set -e

echo "========================================="
echo "  MagicMirror for Raspberry Pi 3B"
echo "  Installation Script"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ]; then
    echo -e "${YELLOW}⚠️  Warning: This doesn't appear to be a Raspberry Pi${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check architecture
ARCH=$(uname -m)
echo -e "${BLUE}Architecture: $ARCH${NC}"
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "armv7l" ]; then
    echo -e "${YELLOW}⚠️  Warning: Expected aarch64 or armv7l, got $ARCH${NC}"
fi

# Update system
echo ""
echo -e "${BLUE}📦 Updating system packages...${NC}"
sudo apt update

# Install required packages
echo ""
echo -e "${BLUE}📦 Installing required packages...${NC}"
sudo apt install -y \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    libatlas-base-dev \
    libopenblas-dev \
    libjpeg-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libcanberra-gtk-module \
    libcanberra-gtk3-module

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
echo ""
echo -e "${BLUE}Node.js version: $(node -v)${NC}"

if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${YELLOW}⚠️  Node.js version is too old. Installing Node.js 20...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    echo -e "${GREEN}✅ Node.js updated to $(node -v)${NC}"
fi

# Navigate to MagicMirror directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/MagicMirror"

# Install MagicMirror dependencies
echo ""
echo -e "${BLUE}📦 Installing MagicMirror dependencies...${NC}"
echo -e "${YELLOW}⏳ This may take 10-20 minutes on Raspberry Pi 3B...${NC}"
npm install --no-audit --no-fund --no-update-notifier

# Setup Python virtual environment
echo ""
echo -e "${BLUE}🐍 Setting up Python environment...${NC}"
if [ ! -d "assistant_env" ]; then
    python3 -m venv assistant_env
fi

source assistant_env/bin/activate
pip3 install --upgrade pip
pip3 install google-generativeai requests flask
deactivate

# Copy optimized config if no config exists
if [ ! -f "config/config.js" ]; then
    echo ""
    echo -e "${BLUE}📝 Creating optimized configuration for Pi 3B...${NC}"
    cp config/config_pi3b.js config/config.js
    echo -e "${GREEN}✅ Configuration created${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  config.js already exists. Optimized config saved as config_pi3b.js${NC}"
fi

# Increase swap space
echo ""
echo -e "${BLUE}💾 Checking swap space...${NC}"
CURRENT_SWAP=$(grep CONF_SWAPSIZE /etc/dphys-swapfile | cut -d'=' -f2)
if [ "$CURRENT_SWAP" -lt 2048 ]; then
    echo -e "${YELLOW}⚠️  Current swap: ${CURRENT_SWAP}MB. Recommended: 2048MB${NC}"
    read -p "Increase swap space to 2048MB? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
        sudo dphys-swapfile setup
        sudo dphys-swapfile swapon
        echo -e "${GREEN}✅ Swap space increased to 2048MB${NC}"
    fi
else
    echo -e "${GREEN}✅ Swap space is adequate: ${CURRENT_SWAP}MB${NC}"
fi

# Setup PM2 for auto-start
echo ""
read -p "Install PM2 for auto-start on boot? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}📦 Installing PM2...${NC}"
    sudo npm install -g pm2
    echo -e "${GREEN}✅ PM2 installed${NC}"
    echo ""
    echo -e "${BLUE}To setup auto-start, run:${NC}"
    echo -e "  cd $SCRIPT_DIR/MagicMirror"
    echo -e "  pm2 start npm --name magicmirror -- start"
    echo -e "  pm2 save"
    echo -e "  pm2 startup"
fi

# API Key setup
echo ""
echo -e "${BLUE}🔑 Google Gemini API Key Setup${NC}"
echo -e "The AI Assistant requires a Google Gemini API key."
echo -e "Get your key at: ${YELLOW}https://makersuite.google.com/app/apikey${NC}"
echo ""
read -p "Do you have an API key to configure now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter your Google Gemini API key: " API_KEY
    if [ ! -z "$API_KEY" ]; then
        sed -i "s/YOUR_API_KEY_HERE/$API_KEY/" assistant_bridge_simple.py
        echo -e "${GREEN}✅ API key configured${NC}"
    fi
fi

# Installation complete
echo ""
echo "========================================="
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo "========================================="
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "1. Start MagicMirror:"
echo -e "   ${YELLOW}cd $SCRIPT_DIR/MagicMirror${NC}"
echo -e "   ${YELLOW}npm start${NC}"
echo ""
echo "2. Or use server mode (recommended for Pi 3B):"
echo -e "   ${YELLOW}npm run server${NC}"
echo -e "   Then open: ${YELLOW}http://$(hostname -I | awk '{print $1}'):8080${NC}"
echo ""
echo "3. For auto-start on boot:"
echo -e "   ${YELLOW}pm2 start npm --name magicmirror -- start${NC}"
echo -e "   ${YELLOW}pm2 save${NC}"
echo -e "   ${YELLOW}pm2 startup${NC}"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  - RASPBERRY_PI_SETUP.md - Complete Pi setup guide"
echo "  - QUICK_START.md - Quick start guide"
echo "  - PROJECT_STATUS.md - Project status and troubleshooting"
echo ""
echo -e "${YELLOW}⚠️  Note: First boot may take 1-2 minutes on Pi 3B${NC}"
echo ""
