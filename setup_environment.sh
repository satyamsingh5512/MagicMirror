#!/bin/bash

# =============================================================================
# Python Environment Setup Script for MagicMirror AI Assistant
# =============================================================================
# This script sets up the Python virtual environment and installs all
# required packages for the AI assistant functionality
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"
PYTHON_ENV_DIR="$MAGICMIRROR_DIR/assistant_env"
REQUIREMENTS_FILE="$PROJECT_DIR/assistant1/requirements.txt"

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

# =============================================================================
# Check Prerequisites
# =============================================================================

check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check Python
    if ! command -v python3 >/dev/null 2>&1; then
        print_error "Python 3 not found. Please install Python 3.8 or higher."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_success "Python: v$PYTHON_VERSION"
    
    # Check pip
    if ! command -v pip3 >/dev/null 2>&1; then
        print_error "pip3 not found. Please install pip3."
        exit 1
    fi
    
    print_success "pip3: Available"
    
    # Check venv module
    if ! python3 -c "import venv" 2>/dev/null; then
        print_error "Python venv module not found. Please install python3-venv."
        exit 1
    fi
    
    print_success "Python venv module: Available"
}

# =============================================================================
# Install System Audio Dependencies
# =============================================================================

install_audio_dependencies() {
    print_header "Installing Audio Dependencies"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Installing Linux audio dependencies..."
        
        # Detect package manager
        if command -v apt-get >/dev/null 2>&1; then
            print_info "Using apt package manager"
            sudo apt-get update
            sudo apt-get install -y \
                portaudio19-dev \
                python3-pyaudio \
                libasound2-dev \
                libpulse-dev \
                alsa-utils \
                pulseaudio \
                espeak \
                espeak-data \
                libespeak-dev \
                build-essential \
                python3-dev
                
        elif command -v yum >/dev/null 2>&1; then
            print_info "Using yum package manager"
            sudo yum install -y \
                portaudio-devel \
                alsa-lib-devel \
                pulseaudio-libs-devel \
                espeak \
                espeak-devel \
                gcc \
                python3-devel
                
        elif command -v pacman >/dev/null 2>&1; then
            print_info "Using pacman package manager"
            sudo pacman -S --noconfirm \
                portaudio \
                alsa-lib \
                pulseaudio \
                espeak \
                base-devel \
                python
        else
            print_warning "Unknown package manager. Please install audio dependencies manually:"
            print_info "- portaudio development libraries"
            print_info "- ALSA development libraries"
            print_info "- PulseAudio development libraries"
            print_info "- espeak and espeak development libraries"
            print_info "- build-essential / development tools"
        fi
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Installing macOS audio dependencies..."
        
        if command -v brew >/dev/null 2>&1; then
            brew install portaudio espeak
        else
            print_warning "Homebrew not found. Please install manually:"
            print_info "- portaudio"
            print_info "- espeak"
        fi
    fi
    
    print_success "Audio dependencies installed"
}

# =============================================================================
# Create Python Virtual Environment
# =============================================================================

create_virtual_environment() {
    print_header "Creating Python Virtual Environment"
    
    # Remove existing environment if it exists
    if [ -d "$PYTHON_ENV_DIR" ]; then
        print_warning "Existing Python environment found. Removing..."
        rm -rf "$PYTHON_ENV_DIR"
    fi
    
    # Create new virtual environment
    print_info "Creating virtual environment at: $PYTHON_ENV_DIR"
    python3 -m venv "$PYTHON_ENV_DIR"
    
    # Activate virtual environment
    source "$PYTHON_ENV_DIR/bin/activate"
    
    # Upgrade pip and setuptools
    print_info "Upgrading pip and setuptools..."
    pip install --upgrade pip setuptools wheel
    
    print_success "Virtual environment created and activated"
}

# =============================================================================
# Install Python Packages
# =============================================================================

install_python_packages() {
    print_header "Installing Python Packages"
    
    # Ensure virtual environment is activated
    source "$PYTHON_ENV_DIR/bin/activate"
    
    # Core AI Assistant packages
    print_info "Installing core AI assistant packages..."
    
    # Install packages one by one for better error handling
    packages=(
        "speechrecognition"
        "pyttsx3"
        "google-generativeai"
        "requests"
        "python-dotenv"
    )
    
    for package in "${packages[@]}"; do
        print_info "Installing $package..."
        pip install "$package"
        print_success "$package installed"
    done
    
    # Install PyAudio (can be tricky)
    print_info "Installing PyAudio (audio processing)..."
    if pip install pyaudio; then
        print_success "PyAudio installed successfully"
    else
        print_warning "PyAudio installation failed. Trying alternative method..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Try installing system package first
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y python3-pyaudio
                pip install pyaudio
            else
                print_error "PyAudio installation failed. Please install manually."
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS specific PyAudio installation
            pip install --global-option='build_ext' --global-option='-I/usr/local/include' --global-option='-L/usr/local/lib' pyaudio
        fi
    fi
    
    # Additional useful packages
    print_info "Installing additional packages..."
    additional_packages=(
        "numpy"
        "opencv-python"
        "Pillow"
        "websockets"
        "aiohttp"
    )
    
    for package in "${additional_packages[@]}"; do
        print_info "Installing $package..."
        pip install "$package" || print_warning "Failed to install $package (optional)"
    done
    
    print_success "Python packages installation complete"
}

# =============================================================================
# Test Installation
# =============================================================================

test_installation() {
    print_header "Testing Installation"
    
    # Activate virtual environment
    source "$PYTHON_ENV_DIR/bin/activate"
    
    # Test imports
    print_info "Testing Python package imports..."
    
    python3 << 'EOF'
import sys
import traceback

packages_to_test = [
    ("speech_recognition", "Speech Recognition"),
    ("pyttsx3", "Text-to-Speech"),
    ("google.generativeai", "Google Generative AI"),
    ("requests", "HTTP Requests"),
    ("pyaudio", "Audio Processing"),
    ("numpy", "NumPy"),
    ("cv2", "OpenCV"),
    ("PIL", "Pillow")
]

success_count = 0
total_count = len(packages_to_test)

for package, name in packages_to_test:
    try:
        __import__(package)
        print(f"✅ {name}: OK")
        success_count += 1
    except ImportError as e:
        print(f"❌ {name}: FAILED - {e}")
    except Exception as e:
        print(f"⚠️  {name}: WARNING - {e}")

print(f"\n📊 Test Results: {success_count}/{total_count} packages imported successfully")

if success_count >= 5:  # Core packages
    print("🎉 Installation test PASSED - Core functionality available")
    sys.exit(0)
else:
    print("❌ Installation test FAILED - Missing critical packages")
    sys.exit(1)
EOF

    if [ $? -eq 0 ]; then
        print_success "Installation test passed"
    else
        print_error "Installation test failed"
        return 1
    fi
}

# =============================================================================
# Create Test Scripts
# =============================================================================

create_test_scripts() {
    print_header "Creating Test Scripts"
    
    # Create microphone test script
    cat > "$PROJECT_DIR/test_microphone.py" << 'EOF'
#!/usr/bin/env python3

import speech_recognition as sr
import sys
import time

def test_microphone():
    """Test microphone functionality"""
    print("🎤 Testing Microphone...")
    
    r = sr.Recognizer()
    
    # List available microphones
    print("\n📋 Available Microphones:")
    for index, name in enumerate(sr.Microphone.list_microphone_names()):
        print(f"  {index}: {name}")
    
    # Test microphone
    try:
        with sr.Microphone() as source:
            print("\n🔧 Adjusting for ambient noise... (please be quiet)")
            r.adjust_for_ambient_noise(source, duration=2)
            
            print("🎯 Say something! (You have 5 seconds)")
            audio = r.listen(source, timeout=5, phrase_time_limit=5)
            
            print("🔄 Processing audio...")
            text = r.recognize_google(audio)
            print(f"✅ You said: '{text}'")
            
    except sr.UnknownValueError:
        print("❌ Could not understand audio")
    except sr.RequestError as e:
        print(f"❌ Error with speech recognition service: {e}")
    except sr.WaitTimeoutError:
        print("⏰ No speech detected within timeout")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    test_microphone()
EOF

    # Create speaker test script
    cat > "$PROJECT_DIR/test_speaker.py" << 'EOF'
#!/usr/bin/env python3

import pyttsx3
import sys

def test_speaker():
    """Test speaker/text-to-speech functionality"""
    print("🔊 Testing Speaker/Text-to-Speech...")
    
    try:
        engine = pyttsx3.init()
        
        # Get available voices
        voices = engine.getProperty('voices')
        print(f"\n📋 Available Voices: {len(voices)}")
        for i, voice in enumerate(voices[:3]):  # Show first 3
            print(f"  {i}: {voice.name}")
        
        # Test speech
        test_text = "Hello! This is a test of the text to speech system. Can you hear me clearly?"
        print(f"\n🎯 Speaking: '{test_text}'")
        
        engine.say(test_text)
        engine.runAndWait()
        
        print("✅ Speaker test completed")
        
    except Exception as e:
        print(f"❌ Speaker test failed: {e}")

if __name__ == "__main__":
    test_speaker()
EOF

    # Create AI test script
    cat > "$PROJECT_DIR/test_ai.py" << 'EOF'
#!/usr/bin/env python3

import google.generativeai as genai
import sys
import os

def test_ai():
    """Test Google Generative AI functionality"""
    print("🤖 Testing Google Generative AI...")
    
    # Try to get API key
    api_key = 'YOUR_API_KEY_HERE'  # Replace with your API key
    
    if not api_key:
        print("❌ No API key found")
        print("💡 Set GOOGLE_API_KEY environment variable or update the script")
        return
    
    try:
        genai.configure(api_key=api_key)
        
        # Try different models
        models_to_try = ["gemini-1.5-flash", "gemini-1.0-pro", "gemini-pro"]
        
        for model_name in models_to_try:
            try:
                print(f"\n🔄 Testing {model_name}...")
                model = genai.GenerativeModel(model_name)
                
                response = model.generate_content("Say hello and tell me you're working correctly")
                print(f"✅ {model_name}: {response.text[:100]}...")
                break
                
            except Exception as e:
                print(f"❌ {model_name} failed: {e}")
                continue
        else:
            print("❌ All AI models failed")
            print("💡 This might be due to API quota limits")
            print("🔑 Get a free API key at: https://makersuite.google.com/app/apikey")
            
    except Exception as e:
        print(f"❌ AI test failed: {e}")

if __name__ == "__main__":
    test_ai()
EOF

    # Make test scripts executable
    chmod +x "$PROJECT_DIR/test_microphone.py"
    chmod +x "$PROJECT_DIR/test_speaker.py"
    chmod +x "$PROJECT_DIR/test_ai.py"
    
    print_success "Test scripts created"
}

# =============================================================================
# Create Environment Activation Script
# =============================================================================

create_activation_script() {
    print_header "Creating Environment Activation Script"
    
    cat > "$PROJECT_DIR/activate_env.sh" << EOF
#!/bin/bash

# Activate Python Virtual Environment for MagicMirror AI Assistant
# ===============================================================

PYTHON_ENV_DIR="$PYTHON_ENV_DIR"

if [ ! -d "\$PYTHON_ENV_DIR" ]; then
    echo "❌ Python environment not found: \$PYTHON_ENV_DIR"
    echo "💡 Run ./setup_environment.sh to create it"
    exit 1
fi

echo "🐍 Activating Python virtual environment..."
source "\$PYTHON_ENV_DIR/bin/activate"

echo "✅ Environment activated!"
echo "🎯 Python: \$(which python)"
echo "📦 Pip: \$(which pip)"

# Show installed packages
echo ""
echo "📋 Installed packages:"
pip list | head -10

echo ""
echo "💡 To deactivate, run: deactivate"
echo "🧪 To test components:"
echo "   ./test_microphone.py"
echo "   ./test_speaker.py" 
echo "   ./test_ai.py"

# Keep shell open with environment activated
exec "\$SHELL"
EOF

    chmod +x "$PROJECT_DIR/activate_env.sh"
    
    print_success "Environment activation script created"
}

# =============================================================================
# Main Function
# =============================================================================

main() {
    print_header "Python Environment Setup for MagicMirror AI Assistant"
    
    echo -e "${BLUE}This script will:${NC}"
    echo "🐍 Create Python virtual environment"
    echo "📦 Install all required Python packages"
    echo "🎤 Set up audio dependencies"
    echo "🧪 Create test scripts"
    echo "✅ Verify installation"
    echo ""
    
    read -p "Continue with Python environment setup? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    
    # Run setup steps
    check_prerequisites
    install_audio_dependencies
    create_virtual_environment
    install_python_packages
    test_installation
    create_test_scripts
    create_activation_script
    
    # Success message
    print_header "Python Environment Setup Complete! 🎉"
    
    echo -e "${GREEN}✅ Python virtual environment created successfully!${NC}"
    echo ""
    echo -e "${BLUE}Environment location:${NC} $PYTHON_ENV_DIR"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. 🧪 Test components:"
    echo "   ${YELLOW}./test_microphone.py${NC} - Test microphone"
    echo "   ${YELLOW}./test_speaker.py${NC} - Test text-to-speech"
    echo "   ${YELLOW}./test_ai.py${NC} - Test AI functionality"
    echo ""
    echo "2. 🐍 Activate environment manually:"
    echo "   ${YELLOW}./activate_env.sh${NC}"
    echo ""
    echo "3. 🚀 Continue with main installation:"
    echo "   ${YELLOW}./install.sh${NC}"
    echo ""
    echo -e "${GREEN}Python environment is ready! 🐍✨${NC}"
}

# Run main function
main "$@"