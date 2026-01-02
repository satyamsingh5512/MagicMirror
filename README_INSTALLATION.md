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
