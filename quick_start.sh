#!/bin/bash

# =============================================================================
# MagicMirror AI Assistant - Quick Start Script
# =============================================================================
# One-command installation and startup for the complete MagicMirror AI system
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGICMIRROR_DIR="$PROJECT_DIR/MagicMirror"

# =============================================================================
# Utility Functions
# =============================================================================

print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                              ║"
    echo "║                    🪞 MagicMirror AI Assistant 🤖                           ║"
    echo "║                                                                              ║"
    echo "║                         Quick Start Installation                             ║"
    echo "║                                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
}

print_header() {
    echo -e "\n${CYAN}▶ $1${NC}"
    echo -e "${CYAN}$(printf '%.0s─' {1..60})${NC}"
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

print_step() {
    echo -e "${PURPLE}🔄 $1${NC}"
}

# =============================================================================
# Check if already installed
# =============================================================================

check_existing_installation() {
    print_header "Checking Existing Installation"
    
    if [ -f "$MAGICMIRROR_DIR/package.json" ] && [ -d "$MAGICMIRROR_DIR/node_modules" ]; then
        print_success "MagicMirror already installed"
        
        if [ -f "$MAGICMIRROR_DIR/config/config.js" ]; then
            print_success "Configuration file exists"
            
            if [ -d "$MAGICMIRROR_DIR/assistant_env" ]; then
                print_success "Python environment exists"
                
                echo -e "\n${GREEN}🎉 Installation appears to be complete!${NC}"
                echo -e "${BLUE}Would you like to:${NC}"
                echo "1. 🚀 Start MagicMirror (recommended)"
                echo "2. 🔄 Reinstall everything"
                echo "3. 🧪 Run tests"
                echo "4. ⚙️  Reconfigure"
                echo "5. 🚪 Exit"
                
                read -p "Choose option (1-5): " -n 1 -r
                echo
                
                case $REPLY in
                    1)
                        start_magicmirror
                        exit 0
                        ;;
                    2)
                        print_warning "Proceeding with full reinstallation..."
                        ;;
                    3)
                        run_tests
                        exit 0
                        ;;
                    4)
                        reconfigure_system
                        exit 0
                        ;;
                    5)
                        echo "Goodbye!"
                        exit 0
                        ;;
                    *)
                        print_warning "Invalid option. Proceeding with installation check..."
                        ;;
                esac
            fi
        fi
    fi
}

# =============================================================================
# Quick System Check
# =============================================================================

quick_system_check() {
    print_header "Quick System Check"
    
    # Check Node.js
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version | sed 's/v//')
        if [[ $(echo "$NODE_VERSION 22.18.0" | tr " " "\n" | sort -V | head -n1) == "22.18.0" ]]; then
            print_success "Node.js: v$NODE_VERSION (✓)"
        else
            print_error "Node.js v$NODE_VERSION is too old. Need >= v22.18.0"
            print_info "Please update Node.js: https://nodejs.org/"
            exit 1
        fi
    else
        print_error "Node.js not found. Please install Node.js >= v22.18.0"
        exit 1
    fi
    
    # Check Python
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        print_success "Python: v$PYTHON_VERSION (✓)"
    else
        print_error "Python 3 not found. Please install Python 3.8+"
        exit 1
    fi
    
    # Check basic tools
    for tool in git npm pip3; do
        if command -v $tool >/dev/null 2>&1; then
            print_success "$tool: Available (✓)"
        else
            print_error "$tool not found. Please install $tool"
            exit 1
        fi
    done
}

# =============================================================================
# Run Installation
# =============================================================================

run_installation() {
    print_header "Running Complete Installation"
    
    if [ -f "$PROJECT_DIR/install.sh" ]; then
        print_step "Running main installation script..."
        chmod +x "$PROJECT_DIR/install.sh"
        "$PROJECT_DIR/install.sh"
    else
        print_error "Installation script not found: $PROJECT_DIR/install.sh"
        exit 1
    fi
}

# =============================================================================
# Configure System
# =============================================================================

configure_system() {
    print_header "Configuring System"
    
    if [ -f "$PROJECT_DIR/setup_config.sh" ]; then
        print_step "Running configuration script..."
        chmod +x "$PROJECT_DIR/setup_config.sh"
        "$PROJECT_DIR/setup_config.sh"
    else
        print_warning "Configuration script not found. Using default configuration."
    fi
}

# =============================================================================
# Start MagicMirror
# =============================================================================

start_magicmirror() {
    print_header "Starting MagicMirror"
    
    if [ ! -f "$MAGICMIRROR_DIR/config/config.js" ]; then
        print_error "Configuration file not found!"
        print_info "Please run configuration first: ./setup_config.sh"
        exit 1
    fi
    
    print_step "Starting MagicMirror AI Assistant..."
    print_info "This will open MagicMirror in a new window"
    print_info "Press Ctrl+C to stop"
    
    cd "$MAGICMIRROR_DIR"
    
    # Start the assistant bridge in background
    if [ -f "assistant_bridge_simple.py" ] && [ -d "assistant_env" ]; then
        print_info "Starting AI assistant bridge..."
        ./assistant_env/bin/python assistant_bridge_simple.py demo &
        ASSISTANT_PID=$!
        
        # Give assistant time to start
        sleep 2
    fi
    
    # Start MagicMirror
    print_success "🚀 Launching MagicMirror..."
    npm start
    
    # Clean up assistant process if it was started
    if [ ! -z "$ASSISTANT_PID" ]; then
        kill $ASSISTANT_PID 2>/dev/null || true
    fi
}

# =============================================================================
# Run Tests
# =============================================================================

run_tests() {
    print_header "Running System Tests"
    
    # Test Python environment
    if [ -f "$PROJECT_DIR/test_microphone.py" ]; then
        print_step "Testing microphone..."
        python3 "$PROJECT_DIR/test_microphone.py" || true
    fi
    
    if [ -f "$PROJECT_DIR/test_speaker.py" ]; then
        print_step "Testing speaker..."
        python3 "$PROJECT_DIR/test_speaker.py" || true
    fi
    
    if [ -f "$PROJECT_DIR/test_ai.py" ]; then
        print_step "Testing AI..."
        python3 "$PROJECT_DIR/test_ai.py" || true
    fi
    
    # Test assistant
    if [ -f "$PROJECT_DIR/test_assistant.sh" ]; then
        print_step "Testing AI assistant..."
        chmod +x "$PROJECT_DIR/test_assistant.sh"
        "$PROJECT_DIR/test_assistant.sh" || true
    fi
}

# =============================================================================
# Reconfigure System
# =============================================================================

reconfigure_system() {
    print_header "Reconfiguring System"
    
    echo -e "${BLUE}What would you like to reconfigure?${NC}"
    echo "1. 🔑 API Key (Google Gemini)"
    echo "2. 🌍 Location (currently: Berhampur, Odisha)"
    echo "3. 📰 News Sources"
    echo "4. 🎛️  Full Configuration"
    echo "5. 🔙 Back to main menu"
    
    read -p "Choose option (1-5): " -n 1 -r
    echo
    
    case $REPLY in
        1)
            reconfigure_api_key
            ;;
        2)
            print_info "Location configuration not implemented yet"
            print_info "Edit MagicMirror/config/config.js manually"
            ;;
        3)
            print_info "News source configuration not implemented yet"
            print_info "Edit MagicMirror/config/config.js manually"
            ;;
        4)
            configure_system
            ;;
        5)
            return
            ;;
        *)
            print_warning "Invalid option"
            ;;
    esac
}

reconfigure_api_key() {
    print_header "Reconfiguring API Key"
    
    echo -e "${BLUE}Current API Key Status:${NC}"
    if grep -q "YOUR_API_KEY_HERE" "$MAGICMIRROR_DIR/assistant_bridge_simple.py" 2>/dev/null; then
        print_warning "Using default API key (may be quota exceeded)"
    else
        print_success "Using custom API key"
    fi
    
    echo ""
    echo -e "${YELLOW}💡 Get a free Google Gemini API key:${NC}"
    echo "   https://makersuite.google.com/app/apikey"
    echo ""
    
    read -p "🔐 Enter your new Google Gemini API key (or press Enter to skip): " NEW_API_KEY
    
    if [ -n "$NEW_API_KEY" ]; then
        if [ -f "$MAGICMIRROR_DIR/assistant_bridge_simple.py" ]; then
            # Backup original file
            cp "$MAGICMIRROR_DIR/assistant_bridge_simple.py" "$MAGICMIRROR_DIR/assistant_bridge_simple.py.backup"
            
            # Replace API key
            sed -i "s/api_key = 'YOUR_API_KEY_HERE'/api_key = '$NEW_API_KEY'/" "$MAGICMIRROR_DIR/assistant_bridge_simple.py"
            
            print_success "API key updated successfully!"
            print_info "Backup saved as: assistant_bridge_simple.py.backup"
        else
            print_error "Assistant bridge file not found!"
        fi
    else
        print_info "API key not changed"
    fi
}

# =============================================================================
# Show Help
# =============================================================================

show_help() {
    print_header "Help & Usage"
    
    echo -e "${BLUE}Available Scripts:${NC}"
    echo "🚀 ${YELLOW}./quick_start.sh${NC}     - This script (one-command setup)"
    echo "🔧 ${YELLOW}./install.sh${NC}         - Full installation script"
    echo "⚙️  ${YELLOW}./setup_config.sh${NC}    - Configuration setup"
    echo "🐍 ${YELLOW}./setup_environment.sh${NC} - Python environment setup"
    echo "▶️  ${YELLOW}./start_magicmirror.sh${NC} - Start MagicMirror"
    echo "🧪 ${YELLOW}./test_assistant.sh${NC}   - Test AI assistant"
    echo ""
    
    echo -e "${BLUE}Manual Commands:${NC}"
    echo "📦 ${YELLOW}cd MagicMirror && npm install${NC} - Install MagicMirror"
    echo "🚀 ${YELLOW}cd MagicMirror && npm start${NC}   - Start MagicMirror"
    echo "🧪 ${YELLOW}python3 test_microphone.py${NC}   - Test microphone"
    echo "🔊 ${YELLOW}python3 test_speaker.py${NC}      - Test speaker"
    echo "🤖 ${YELLOW}python3 test_ai.py${NC}           - Test AI"
    echo ""
    
    echo -e "${BLUE}Troubleshooting:${NC}"
    echo "❓ Check README_INSTALLATION.md for detailed instructions"
    echo "🐛 Check terminal output for error messages"
    echo "🔧 Ensure Node.js >= 22.18.0 and Python >= 3.8"
    echo "🎤 Test audio components individually"
    echo "🔑 Get free API key: https://makersuite.google.com/app/apikey"
}

# =============================================================================
# Main Menu
# =============================================================================

show_main_menu() {
    print_header "What would you like to do?"
    
    echo -e "${BLUE}Choose an option:${NC}"
    echo "1. 🚀 Quick Install & Start (Recommended for first time)"
    echo "2. ▶️  Start MagicMirror (if already installed)"
    echo "3. 🔧 Install Only (without starting)"
    echo "4. ⚙️  Configure Only"
    echo "5. 🧪 Run Tests"
    echo "6. 🔄 Reconfigure"
    echo "7. ❓ Help"
    echo "8. 🚪 Exit"
    
    read -p "Enter your choice (1-8): " -n 1 -r
    echo
    
    case $REPLY in
        1)
            quick_install_and_start
            ;;
        2)
            start_magicmirror
            ;;
        3)
            run_installation
            ;;
        4)
            configure_system
            ;;
        5)
            run_tests
            ;;
        6)
            reconfigure_system
            ;;
        7)
            show_help
            show_main_menu
            ;;
        8)
            echo "Goodbye! 👋"
            exit 0
            ;;
        *)
            print_warning "Invalid option. Please choose 1-8."
            show_main_menu
            ;;
    esac
}

# =============================================================================
# Quick Install and Start
# =============================================================================

quick_install_and_start() {
    print_header "Quick Install & Start"
    
    print_step "Step 1/4: System Check"
    quick_system_check
    
    print_step "Step 2/4: Installation"
    run_installation
    
    print_step "Step 3/4: Configuration"
    configure_system
    
    print_step "Step 4/4: Starting MagicMirror"
    start_magicmirror
}

# =============================================================================
# Main Function
# =============================================================================

main() {
    # Clear screen and show banner
    clear
    print_banner
    
    echo -e "${BLUE}Welcome to the MagicMirror AI Assistant Quick Start! 🎉${NC}"
    echo ""
    echo -e "${GREEN}This script will help you:${NC}"
    echo "🪞 Install and configure MagicMirror²"
    echo "🤖 Set up AI voice assistant with Google Gemini"
    echo "📷 Configure HD camera with face detection"
    echo "🌍 Localize for Berhampur, Odisha, India"
    echo "🎯 Set up fallback AI for offline operation"
    echo ""
    
    # Check for existing installation
    check_existing_installation
    
    # Show main menu
    show_main_menu
}

# Handle Ctrl+C gracefully
trap 'echo -e "\n\n${YELLOW}Installation interrupted. You can resume anytime by running ./quick_start.sh${NC}"; exit 1' INT

# Run main function
main "$@"