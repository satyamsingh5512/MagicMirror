#!/bin/bash

# =============================================================================
# MagicMirror AI Assistant - Complete Installation Script
# =============================================================================
# This script installs and configures the complete MagicMirror with AI Assistant
# integration, camera feed, face detection, and localization for Berhampur, India
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="MagicMirror AI Assistant"
PROJECT_DIR="$(pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"
ASSISTANT_DIR="$PROJECT_DIR/assistant1"
PYTHON_ENV_DIR="$MAGICMIRROR_DIR/assistant_env"

# System requirements
MIN_NODE_VERSION="22.18.0"
REQUIRED_PYTHON_VERSION="3.8"

# =============================================================================
# Utility Functions
# =============================================================================

print_header() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

version_compare() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# =============================================================================
# System Requirements Check
# =============================================================================

check_system_requirements() {
    print_header "Checking System Requirements"
    
    # Check operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_success "Operating System: Linux (Supported)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_success "Operating System: macOS (Supported)"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    # Check Node.js
    if check_command node; then
        NODE_VERSION=$(node --version | sed 's/v//')
        if version_compare "$NODE_VERSION" "$MIN_NODE_VERSION"; then
            print_success "Node.js: v$NODE_VERSION (✓ >= v$MIN_NODE_VERSION)"
        else
            print_error "Node.js version v$NODE_VERSION is too old. Required: >= v$MIN_NODE_VERSION"
            print_info "Please update Node.js: https://nodejs.org/"
            exit 1
        fi
    else
        print_error "Node.js not found. Please install Node.js >= v$MIN_NODE_VERSION"
        print_info "Install from: https://nodejs.org/"
        exit 1
    fi
    
    # Check npm
    if check_command npm; then
        NPM_VERSION=$(npm --version)
        print_success "npm: v$NPM_VERSION"
    else
        print_error "npm not found. Please install npm"
        exit 1
    fi
    
    # Check Python
    if check_command python3; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        print_success "Python: v$PYTHON_VERSION"
    else
        print_error "Python 3 not found. Please install Python >= $REQUIRED_PYTHON_VERSION"
        exit 1
    fi
    
    # Check pip
    if check_command pip3; then
        print_success "pip3: Available"
    else
        print_error "pip3 not found. Please install pip3"
        exit 1
    fi
    
    # Check git
    if check_command git; then
        print_success "Git: Available"
    else
        print_error "Git not found. Please install git"
        exit 1
    fi
    
    print_success "All system requirements met!"
}

# =============================================================================
# Install System Dependencies
# =============================================================================

install_system_dependencies() {
    print_header "Installing System Dependencies"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Detect Linux distribution
        if command -v apt-get >/dev/null 2>&1; then
            print_info "Detected Debian/Ubuntu system"
            sudo apt-get update
            sudo apt-get install -y \
                build-essential \
                python3-dev \
                python3-pip \
                python3-venv \
                portaudio19-dev \
                libasound2-dev \
                libpulse-dev \
                alsa-utils \
                pulseaudio \
                espeak \
                espeak-data \
                libespeak-dev \
                ffmpeg \
                git \
                curl \
                wget
        elif command -v yum >/dev/null 2>&1; then
            print_info "Detected RedHat/CentOS system"
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y \
                python3-devel \
                python3-pip \
                portaudio-devel \
                alsa-lib-devel \
                pulseaudio-libs-devel \
                espeak \
                espeak-devel \
                ffmpeg \
                git \
                curl \
                wget
        else
            print_warning "Unknown Linux distribution. Please install dependencies manually:"
            print_info "- build-essential / development tools"
            print_info "- python3-dev"
            print_info "- portaudio development libraries"
            print_info "- alsa development libraries"
            print_info "- espeak and espeak-devel"
            print_info "- ffmpeg"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Detected macOS system"
        if check_command brew; then
            brew install portaudio espeak ffmpeg
        else
            print_warning "Homebrew not found. Please install:"
            print_info "- portaudio"
            print_info "- espeak"
            print_info "- ffmpeg"
        fi
    fi
    
    print_success "System dependencies installed"
}

# =============================================================================
# Setup Python Virtual Environment
# =============================================================================

setup_python_environment() {
    print_header "Setting up Python Virtual Environment"
    
    # Create virtual environment
    if [ -d "$PYTHON_ENV_DIR" ]; then
        print_warning "Python environment already exists. Removing old environment..."
        rm -rf "$PYTHON_ENV_DIR"
    fi
    
    print_info "Creating Python virtual environment..."
    python3 -m venv "$PYTHON_ENV_DIR"
    
    # Activate virtual environment
    source "$PYTHON_ENV_DIR/bin/activate"
    
    # Upgrade pip
    print_info "Upgrading pip..."
    pip install --upgrade pip
    
    # Install Python dependencies
    print_info "Installing Python packages..."
    
    # Core AI assistant dependencies
    pip install \
        speechrecognition \
        pyttsx3 \
        google-generativeai \
        pyaudio \
        requests \
        python-dotenv
    
    # Additional useful packages
    pip install \
        numpy \
        opencv-python \
        Pillow
    
    print_success "Python environment setup complete"
}

# =============================================================================
# Install MagicMirror
# =============================================================================

install_magicmirror() {
    print_header "Installing MagicMirror"
    
    cd "$MAGICMIRROR_DIR"
    
    # Install MagicMirror dependencies
    print_info "Installing MagicMirror dependencies..."
    npm install --no-audit --no-fund --no-update-notifier
    
    # Fix Electron sandbox permissions (Linux specific)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Fixing Electron sandbox permissions..."
        ELECTRON_SANDBOX="$MAGICMIRROR_DIR/node_modules/electron/dist/chrome-sandbox"
        if [ -f "$ELECTRON_SANDBOX" ]; then
            sudo chown root:root "$ELECTRON_SANDBOX"
            sudo chmod 4755 "$ELECTRON_SANDBOX"
            print_success "Electron sandbox permissions fixed"
        else
            print_warning "Electron sandbox not found, skipping permission fix"
        fi
    fi
    
    print_success "MagicMirror installation complete"
}

# =============================================================================
# Setup AI Assistant Module
# =============================================================================

setup_ai_assistant_module() {
    print_header "Setting up AI Assistant Module"
    
    # Create MMM-AIAssistant module directory if it doesn't exist
    MODULE_DIR="$MAGICMIRROR_DIR/modules/MMM-AIAssistant"
    if [ ! -d "$MODULE_DIR" ]; then
        print_error "MMM-AIAssistant module not found!"
        print_info "The module should be in: $MODULE_DIR"
        exit 1
    fi
    
    # Verify module files exist
    if [ ! -f "$MODULE_DIR/MMM-AIAssistant.js" ]; then
        print_error "MMM-AIAssistant.js not found!"
        exit 1
    fi
    
    if [ ! -f "$MODULE_DIR/node_helper.js" ]; then
        print_error "node_helper.js not found!"
        exit 1
    fi
    
    # Verify assistant bridge exists
    if [ ! -f "$MAGICMIRROR_DIR/assistant_bridge_simple.py" ]; then
        print_error "assistant_bridge_simple.py not found!"
        exit 1
    fi
    
    print_success "AI Assistant module verified"
}

# =============================================================================
# Configure Audio System
# =============================================================================

configure_audio_system() {
    print_header "Configuring Audio System"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Test audio output
        print_info "Testing audio output..."
        if command -v speaker-test >/dev/null 2>&1; then
            timeout 3 speaker-test -t sine -f 1000 -l 1 >/dev/null 2>&1 || true
        fi
        
        # Test microphone
        print_info "Testing microphone access..."
        if command -v arecord >/dev/null 2>&1; then
            timeout 2 arecord -d 1 -f cd /tmp/test_audio.wav >/dev/null 2>&1 || true
            rm -f /tmp/test_audio.wav
        fi
        
        print_success "Audio system configured"
    else
        print_info "Audio configuration skipped on macOS (should work by default)"
    fi
}

# =============================================================================
# Create Startup Scripts
# =============================================================================

create_startup_scripts() {
    print_header "Creating Startup Scripts"
    
    # Create main startup script
    cat > "$PROJECT_DIR/start_magicmirror.sh" << 'EOF'
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
EOF

    # Create development startup script
    cat > "$PROJECT_DIR/start_dev.sh" << 'EOF'
#!/bin/bash

# MagicMirror AI Assistant Development Startup Script
# ==================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"

echo "🪞 Starting MagicMirror AI Assistant (Development Mode)..."
cd "$MAGICMIRROR_DIR"
npm run start:dev
EOF

    # Create assistant test script
    cat > "$PROJECT_DIR/test_assistant.sh" << 'EOF'
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
EOF

    # Make scripts executable
    chmod +x "$PROJECT_DIR/start_magicmirror.sh"
    chmod +x "$PROJECT_DIR/start_dev.sh"
    chmod +x "$PROJECT_DIR/test_assistant.sh"
    
    print_success "Startup scripts created"
}

# =============================================================================
# Create Configuration Script
# =============================================================================

create_config_script() {
    print_header "Creating Configuration Script"
    
    cat > "$PROJECT_DIR/setup_config.sh" << 'EOF'
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
EOF

    chmod +x "$PROJECT_DIR/setup_config.sh"
    
    print_success "Configuration script created"
}

# =============================================================================
# Create Documentation
# =============================================================================

create_documentation() {
    print_header "Creating Documentation"
    
    cat > "$PROJECT_DIR/README_INSTALLATION.md" << 'EOF'
# 🪞 MagicMirror AI Assistant - Installation Guide

## 🎯 What This Project Includes

- **MagicMirror²**: Smart mirror platform with modular widgets
- **AI Voice Assistant**: Google Gemini-powered voice interaction
- **HD Camera Feed**: 800x600 camera with real-time face detection
- **Face Detection & Zoom**: Auto-zoom to detected faces
- **Localized for India**: Berhampur weather, Indian news, IST timezone
- **Fallback AI**: Works even without API key

## 🚀 Quick Start

### 1. Install Everything
```bash
./install.sh
```

### 2. Configure (Optional)
```bash
./setup_config.sh
```

### 3. Start MagicMirror
```bash
./start_magicmirror.sh
```

## 🧪 Testing

### Test AI Assistant
```bash
./test_assistant.sh
```

### Development Mode
```bash
./start_dev.sh
```

## 📋 System Requirements

- **Node.js**: >= 22.18.0
- **Python**: >= 3.8
- **Operating System**: Linux or macOS
- **Hardware**: Webcam, microphone, speakers
- **Internet**: For weather, news, and AI features

## 🔧 Manual Installation Steps

If the automatic installer fails, follow these steps:

### 1. Install System Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install build-essential python3-dev python3-pip python3-venv \
    portaudio19-dev libasound2-dev libpulse-dev alsa-utils pulseaudio \
    espeak espeak-data libespeak-dev ffmpeg git curl wget
```

**macOS:**
```bash
brew install portaudio espeak ffmpeg
```

### 2. Setup Python Environment
```bash
cd MagicMirror
python3 -m venv assistant_env
source assistant_env/bin/activate
pip install speechrecognition pyttsx3 google-generativeai pyaudio requests
```

### 3. Install MagicMirror
```bash
cd MagicMirror
npm install
```

### 4. Fix Electron Permissions (Linux)
```bash
sudo chown root:root node_modules/electron/dist/chrome-sandbox
sudo chmod 4755 node_modules/electron/dist/chrome-sandbox
```

## 🔑 API Key Setup

1. Visit: https://makersuite.google.com/app/apikey
2. Create free Google Gemini API key
3. Edit `MagicMirror/assistant_bridge_simple.py`
4. Replace the API key on line ~19

## 🎛️ Configuration

The system is pre-configured for Berhampur, Odisha, India:

- **Weather**: Coordinates 19.3149°N, 84.7941°E
- **News**: Times of India, The Hindu, Odisha TV
- **Time**: Asia/Kolkata timezone
- **Language**: English (India locale)

## 🎮 Usage

### Voice Commands
- "What time is it?"
- "How's the weather?"
- "What's in the news?"
- "Tell me a joke"
- "What can you help me with?"

### Camera Features
- **Auto-start**: Camera starts automatically
- **Face Detection**: Real-time face detection
- **Auto-zoom**: 1.8x zoom on detected faces
- **HD Quality**: 800x600 resolution

### Widgets
- **Clock**: Shows IST time with sunrise/sunset
- **Weather**: Current conditions and 5-day forecast
- **News**: Scrolling Indian news headlines
- **Calendar**: Indian holidays
- **Compliments**: Random compliments

## 🛠️ Troubleshooting

### MagicMirror Won't Start
```bash
# Check Node.js version
node --version  # Should be >= 22.18.0

# Check for errors
cd MagicMirror
npm start
```

### Camera Not Working
- Check camera permissions
- Ensure camera is not used by other apps
- Try different browsers (Chrome recommended)

### AI Assistant Not Responding
- Check if Python environment is activated
- Test with: `./test_assistant.sh`
- Verify API key if using Gemini AI

### Audio Issues
```bash
# Test speakers
speaker-test -t sine -f 1000 -l 1

# Test microphone
arecord -d 3 test.wav && aplay test.wav
```

### Permission Errors
```bash
# Fix Electron sandbox (Linux)
sudo chown root:root MagicMirror/node_modules/electron/dist/chrome-sandbox
sudo chmod 4755 MagicMirror/node_modules/electron/dist/chrome-sandbox
```

## 📁 Project Structure

```
├── MagicMirror/                    # Main MagicMirror application
│   ├── config/config.js           # Configuration file
│   ├── modules/MMM-AIAssistant/    # AI Assistant module
│   ├── assistant_bridge_simple.py # Python AI bridge
│   └── assistant_env/              # Python virtual environment
├── assistant1/                     # Original AI assistant code
├── install.sh                      # Main installation script
├── setup_config.sh                # Configuration setup
├── start_magicmirror.sh           # Start MagicMirror
├── start_dev.sh                   # Development mode
└── test_assistant.sh              # Test AI assistant
```

## 🎯 Features

### ✅ Working Features
- HD camera feed with face detection
- Voice-activated AI assistant
- Weather for Berhampur, Odisha
- Indian news feeds
- Indian Standard Time
- Fallback AI responses
- Auto-zoom on face detection

### 🔄 Fallback Mode
When API quota is exceeded or no API key:
- Time queries → Shows current time
- Weather queries → Points to weather widget
- News queries → Points to news feed
- Jokes → Pre-programmed jokes
- Help → Lists capabilities

## 🆘 Support

### Common Issues
1. **Node.js too old**: Update to >= 22.18.0
2. **Electron sandbox**: Run permission fix script
3. **Camera permissions**: Allow camera access in browser
4. **Audio not working**: Check ALSA/PulseAudio setup
5. **API quota exceeded**: Get your own free API key

### Getting Help
- Check the troubleshooting section above
- Review error messages in terminal
- Test components individually
- Ensure all dependencies are installed

## 🎉 Success Indicators

When everything is working:
- MagicMirror starts without errors
- Camera feed shows in center
- Face detection draws rectangles around faces
- AI assistant responds to voice commands
- Weather shows Berhampur data
- News shows Indian headlines
- Time displays in IST

Enjoy your AI-powered MagicMirror! 🪞✨
EOF

    print_success "Documentation created"
}

# =============================================================================
# Final Verification
# =============================================================================

verify_installation() {
    print_header "Verifying Installation"
    
    # Check MagicMirror directory
    if [ ! -d "$MAGICMIRROR_DIR" ]; then
        print_error "MagicMirror directory not found: $MAGICMIRROR_DIR"
        return 1
    fi
    print_success "MagicMirror directory found"
    
    # Check config file
    if [ ! -f "$MAGICMIRROR_DIR/config/config.js" ]; then
        print_warning "Configuration file not found. Run: ./setup_config.sh"
    else
        print_success "Configuration file exists"
    fi
    
    # Check Python environment
    if [ ! -f "$PYTHON_ENV_DIR/bin/python" ]; then
        print_error "Python environment not found: $PYTHON_ENV_DIR"
        return 1
    fi
    print_success "Python environment created"
    
    # Check AI Assistant module
    if [ ! -d "$MAGICMIRROR_DIR/modules/MMM-AIAssistant" ]; then
        print_error "AI Assistant module not found"
        return 1
    fi
    print_success "AI Assistant module found"
    
    # Check assistant bridge
    if [ ! -f "$MAGICMIRROR_DIR/assistant_bridge_simple.py" ]; then
        print_error "Assistant bridge not found"
        return 1
    fi
    print_success "Assistant bridge found"
    
    # Check startup scripts
    if [ ! -f "$PROJECT_DIR/start_magicmirror.sh" ]; then
        print_error "Startup script not found"
        return 1
    fi
    print_success "Startup scripts created"
    
    print_success "Installation verification complete!"
}

# =============================================================================
# Main Installation Process
# =============================================================================

main() {
    print_header "MagicMirror AI Assistant - Complete Installation"
    
    echo -e "${BLUE}This script will install and configure:${NC}"
    echo "🪞 MagicMirror² with AI Assistant integration"
    echo "📷 HD camera feed with face detection"
    echo "🤖 Google Gemini AI voice assistant"
    echo "🌍 Localized for Berhampur, Odisha, India"
    echo "🎯 Fallback AI for offline operation"
    echo ""
    
    read -p "Continue with installation? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    # Run installation steps
    check_system_requirements
    install_system_dependencies
    setup_python_environment
    install_magicmirror
    setup_ai_assistant_module
    configure_audio_system
    create_startup_scripts
    create_config_script
    create_documentation
    verify_installation
    
    # Final success message
    print_header "Installation Complete! 🎉"
    
    echo -e "${GREEN}✅ MagicMirror AI Assistant installed successfully!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. 🔧 Configure the system: ${YELLOW}./setup_config.sh${NC}"
    echo "2. 🚀 Start MagicMirror: ${YELLOW}./start_magicmirror.sh${NC}"
    echo "3. 🧪 Test AI Assistant: ${YELLOW}./test_assistant.sh${NC}"
    echo ""
    echo -e "${BLUE}Features included:${NC}"
    echo "📷 HD camera with face detection and auto-zoom"
    echo "🤖 AI voice assistant with Google Gemini"
    echo "🌤️  Weather for Berhampur, Odisha, India"
    echo "📰 Indian news feeds (Times of India, The Hindu, etc.)"
    echo "🕐 Indian Standard Time with local holidays"
    echo "🎯 Fallback AI responses (works without API key)"
    echo ""
    echo -e "${YELLOW}💡 Pro tip: Get a free Google Gemini API key for full AI features!${NC}"
    echo "   Visit: https://makersuite.google.com/app/apikey"
    echo ""
    echo -e "${GREEN}Happy mirroring! 🪞✨${NC}"
}

# Run main function
main "$@"