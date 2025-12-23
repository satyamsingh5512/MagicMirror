# 🪞 MagicMirror AI Assistant

Complete smart mirror with AI voice assistant, HD camera, face detection, and Indian localization.

## 🚀 Quick Start

### One-Command Installation
```bash
./quick_start.sh
```

### Manual Installation
```bash
./install.sh          # Install everything
./setup_config.sh     # Configure (optional)
./start_magicmirror.sh # Start MagicMirror
```

## 🎯 Features

- 🪞 **Smart Mirror**: Weather, news, time, calendar for Berhampur, Odisha, India
- 🤖 **AI Assistant**: Voice-activated with Google Gemini + fallback responses
- 📷 **HD Camera**: 800x600 with real-time face detection and auto-zoom
- 🔊 **Audio**: Speech recognition and text-to-speech
- 🌍 **Localized**: Indian news, weather, time zone, holidays

## 📋 Requirements

- **Node.js**: >= 22.18.0
- **Python**: >= 3.8
- **OS**: Linux or macOS
- **Hardware**: Camera, microphone, speakers

## 📚 Documentation

- **`INSTALLATION_SUMMARY.md`** - Complete setup guide
- **`docs/api_key_setup_guide.md`** - API key instructions
- **`docs/summaries/`** - Development notes

## 🧪 Testing

```bash
./test_assistant.sh         # Test AI assistant
python3 test_microphone.py  # Test microphone
python3 test_speaker.py     # Test speakers
python3 test_ai.py          # Test AI connection
```

## 🔑 API Key (Optional)

Get free Google Gemini API key: https://makersuite.google.com/app/apikey

System works perfectly with fallback responses even without API key!

## 🎉 Ready to Use!

Your AI-powered MagicMirror with camera, voice interaction, and Indian localization is ready for installation. Run `./quick_start.sh` to begin!