# 🪞 MagicMirror AI Assistant

> **Smart Mirror with AI Voice Assistant - Optimized for Raspberry Pi 3B (aarch64)**

Complete smart mirror with AI voice assistant, HD camera, face detection, and Indian localization.

---

## 🎯 For Raspberry Pi 3B Users - START HERE!

### 📘 **[README_PI.md](README_PI.md)** ← Click here for Pi setup!

### Quick Installation on Raspberry Pi
```bash
git clone https://github.com/satyamsingh5512/MagicMirror.git
cd MagicMirror
./install_pi.sh
```

Then start:
```bash
cd MagicMirror
npm run server  # Recommended for Pi 3B
```

Access at: `http://[YOUR_PI_IP]:8080`

---

## 📚 Raspberry Pi Documentation

| Document | Purpose |
|----------|---------|
| **[README_PI.md](README_PI.md)** | 🚀 Main Pi guide - Start here! |
| **[RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md)** | 📘 Complete setup instructions |
| **[PI_QUICK_REFERENCE.md](PI_QUICK_REFERENCE.md)** | 📗 Quick command reference |
| **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)** | 📊 Deployment checklist |

---

## 🎯 Features

- 🪞 **Smart Mirror**: Weather, news, time, calendar for Berhampur, Odisha, India
- 🤖 **AI Assistant**: Voice-activated with Google Gemini + fallback responses
- 📷 **HD Camera**: Real-time face detection and auto-zoom
- 🔊 **Audio**: Speech recognition and text-to-speech
- 🌍 **Localized**: Indian news, weather, time zone, holidays
- ⚡ **Optimized**: Special configuration for Raspberry Pi 3B (1GB RAM)

## 📋 Requirements

### For Raspberry Pi 3B
- **Hardware**: Raspberry Pi 3B (aarch64)
- **RAM**: 1GB (optimized configuration included)
- **Storage**: 16GB+ SD card (Class 10)
- **OS**: Raspberry Pi OS 64-bit
- **Display**: HDMI monitor
- **Optional**: USB camera, microphone, speakers

### Software (Auto-installed)
- **Node.js**: >= 18 (20+ recommended)
- **Python**: >= 3.8
- **npm**: >= 10

## 🚀 Quick Start (Other Systems)

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

## 📚 General Documentation

- **[QUICK_START.md](QUICK_START.md)** - General quick start guide
- **[PROJECT_STATUS.md](PROJECT_STATUS.md)** - Project status and troubleshooting
- **[INSTALLATION_SUMMARY.md](INSTALLATION_SUMMARY.md)** - Complete setup guide
- **`docs/api_key_setup_guide.md`** - API key instructions
- **`docs/summaries/`** - Development notes

## 🔧 Configuration

### Raspberry Pi 3B (Optimized)
Pre-configured for best performance:
- 5 modules (reduced from 8)
- Disabled animations
- Longer update intervals
- Server mode recommended
- Network accessible

Configuration file: `MagicMirror/config/config_pi3b.js`

### Standard Configuration
Full-featured configuration for more powerful systems.

Configuration file: `MagicMirror/config/config.js`

## 🧪 Testing

```bash
./test_assistant.sh         # Test AI assistant
python3 test_microphone.py  # Test microphone
python3 test_speaker.py     # Test speakers
python3 test_ai.py          # Test AI connection
```

## 🔑 API Key Setup

### Get Google Gemini API Key
Visit: https://makersuite.google.com/app/apikey

### Add to Configuration
```bash
nano MagicMirror/assistant_bridge_simple.py
```
Change line 19:
```python
api_key = os.getenv('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
```

**Note**: System works with fallback responses even without API key!

## 📊 Performance on Raspberry Pi 3B

| Mode | RAM Usage | CPU Usage | Startup Time |
|------|-----------|-----------|--------------|
| **Server Mode** (Recommended) | ~400MB | 30-50% | 20-30s |
| Optimized Config | ~500MB | 40-60% | 30-45s |
| Full Config | ~800MB | 60-80% | 45-60s |

## 🌐 Network Access

### Find Your Pi's IP
```bash
hostname -I
```

### Access from Any Device
```
http://[PI_IP_ADDRESS]:8080
```

Works on:
- Desktop browsers
- Mobile phones
- Tablets
- Other computers on the network

## 🎨 Modules Included

### Default Modules (Optimized for Pi)
- ⏰ **Clock** - IST timezone, Berhampur sunrise/sunset
- 📅 **Calendar** - Indian holidays
- 🌤️ **Weather** - Berhampur current weather (OpenMeteo)
- 📰 **News** - Times of India feed
- 💬 **Compliments** - Random compliments

### Optional Modules
- 🤖 **AI Assistant** - Voice interaction (requires API key + camera)
- 🌦️ **Weather Forecast** - 5-day forecast (disabled for performance)
- 📰 **Multiple News Feeds** - Additional news sources

## 🛠️ Troubleshooting

### Raspberry Pi Issues
See: [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md#troubleshooting)

### Common Issues
- **Out of Memory**: Increase swap space (see Pi docs)
- **Slow Performance**: Use server mode, reduce modules
- **Can't Access**: Check firewall, use `address: "0.0.0.0"`
- **Display Issues**: Check HDMI settings in `/boot/config.txt`

## 🔄 Updates

### Update MagicMirror
```bash
cd ~/MagicMirror
git pull origin main
cd MagicMirror
npm install
```

### Update System (Raspberry Pi)
```bash
sudo apt update && sudo apt upgrade -y
```

## 💾 Backup

### Configuration Backup
```bash
cp MagicMirror/config/config.js config_backup.js
```

### Full SD Card Backup (Pi)
From another computer:
```bash
sudo dd if=/dev/sdX of=~/magicmirror_backup.img bs=4M status=progress
```

## 📱 Mobile Access

Access your MagicMirror from phone/tablet:
1. Connect to same WiFi network
2. Open browser
3. Go to: `http://[PI_IP]:8080`

## 🎉 Ready to Use!

### For Raspberry Pi 3B:
1. Read **[README_PI.md](README_PI.md)**
2. Run `./install_pi.sh`
3. Start with `npm run server`
4. Access at `http://[PI_IP]:8080`

### For Other Systems:
1. Run `./quick_start.sh`
2. Follow on-screen instructions

## 📞 Support

- **Pi Setup**: [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md)
- **Quick Reference**: [PI_QUICK_REFERENCE.md](PI_QUICK_REFERENCE.md)
- **Forum**: https://forum.magicmirror.builders/
- **Issues**: https://github.com/satyamsingh5512/MagicMirror/issues

## 🏆 Optimized for Raspberry Pi 3B

This project includes special optimizations for Raspberry Pi 3B:
- ✅ Reduced memory footprint
- ✅ Disabled resource-intensive features
- ✅ Longer update intervals
- ✅ Server mode support
- ✅ Network accessible by default
- ✅ Automated installation
- ✅ Complete documentation

---

**Last Updated**: 2026-01-03  
**Target Platform**: Raspberry Pi 3B (aarch64)  
**Status**: ✅ Production Ready
