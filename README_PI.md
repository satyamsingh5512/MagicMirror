# MagicMirror for Raspberry Pi 3B

> **Optimized configuration for Raspberry Pi 3B (aarch64) with 1GB RAM**

## 🚀 Quick Start (3 Steps)

### 1. Clone Repository
```bash
git clone https://github.com/satyamsingh5512/MagicMirror.git
cd MagicMirror
```

### 2. Run Installation Script
```bash
./install_pi.sh
```
This will:
- Install all dependencies
- Setup Python environment
- Create optimized configuration
- Increase swap space
- Configure PM2 (optional)

### 3. Start MagicMirror
```bash
cd MagicMirror
npm run server  # Recommended for Pi 3B
```

Access at: `http://[YOUR_PI_IP]:8080`

## 📋 What's Included

### Optimized Configuration
- **Reduced modules** (5 instead of 8) for better performance
- **Disabled animations** to reduce CPU usage
- **Longer update intervals** to save bandwidth
- **Network accessible** from any device
- **Single news feed** instead of multiple

### Documentation
- 📘 **RASPBERRY_PI_SETUP.md** - Complete setup guide
- 📗 **PI_QUICK_REFERENCE.md** - Quick command reference
- 📙 **QUICK_START.md** - General quick start
- 📕 **PROJECT_STATUS.md** - Project status and troubleshooting

### Scripts
- `install_pi.sh` - Automated installation
- `run_magicmirror.sh` - Quick start script

## 🎯 Recommended Setup for Pi 3B

### Hardware
- Raspberry Pi 3B (aarch64)
- 16GB+ SD card (Class 10)
- 2.5A power supply
- HDMI display
- USB camera (optional, for AI Assistant)

### Software
- Raspberry Pi OS 64-bit (Lite or Desktop)
- Node.js 20+
- Python 3.9+

## 📊 Performance Expectations

| Mode | RAM Usage | CPU Usage | Startup Time |
|------|-----------|-----------|--------------|
| **Server Mode** (Recommended) | ~400MB | 30-50% | 20-30s |
| Optimized Config | ~500MB | 40-60% | 30-45s |
| Full Config | ~800MB | 60-80% | 45-60s |

## 🔧 Configuration Options

### Option 1: Server Mode (Recommended)
Best performance, access via browser from any device:
```bash
cd MagicMirror
npm run server
```

### Option 2: Full Mode
Runs Electron on the Pi:
```bash
cd MagicMirror
npm start
```

### Option 3: Auto-start on Boot
```bash
cd MagicMirror
pm2 start npm --name magicmirror -- start
pm2 save
pm2 startup
```

## 🌐 Network Access

### Find Your Pi's IP
```bash
hostname -I
```

### Access from Browser
```
http://192.168.1.XXX:8080
```

### Set Static IP (Recommended)
```bash
sudo nano /etc/dhcpcd.conf
```
Add:
```
interface eth0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=8.8.8.8
```

## 🎨 Customization

### Edit Configuration
```bash
nano ~/MagicMirror/MagicMirror/config/config.js
```

### Add More Modules
Browse available modules:
https://github.com/MagicMirrorOrg/MagicMirror/wiki/3rd-party-modules

### Change Location
Edit `config.js`:
```javascript
lat: 19.3149,  // Your latitude
lon: 84.7941,  // Your longitude
timeZone: "Asia/Kolkata",
```

## 🔑 AI Assistant Setup

### 1. Get API Key
Visit: https://makersuite.google.com/app/apikey

### 2. Add to Configuration
```bash
nano ~/MagicMirror/MagicMirror/assistant_bridge_simple.py
```
Change line 19:
```python
api_key = os.getenv('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
```

### 3. Enable Camera
```bash
sudo raspi-config
# Interface Options > Camera > Enable
sudo reboot
```

### 4. Uncomment AI Module
Edit `config/config.js` and uncomment the MMM-AIAssistant section

## 🛠️ Troubleshooting

### Issue: Out of Memory
**Solution:**
```bash
# Increase swap
sudo nano /etc/dphys-swapfile
# Set CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### Issue: Slow Performance
**Solution:**
- Use server mode instead of full mode
- Reduce number of modules
- Disable animations in config
- Use optimized config: `cp config/config_pi3b.js config/config.js`

### Issue: Display Not Working
**Solution:**
```bash
sudo nano /boot/config.txt
# Add:
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82
```

### Issue: Can't Access from Network
**Solution:**
```bash
# Check config.js has:
address: "0.0.0.0",
ipWhitelist: [],

# Check firewall:
sudo ufw allow 8080
```

## 📱 Mobile Access

Access your MagicMirror from phone/tablet:
1. Connect to same WiFi network
2. Open browser
3. Go to: `http://[PI_IP]:8080`

## 🔄 Updates

### Update MagicMirror
```bash
cd ~/MagicMirror
git pull origin main
cd MagicMirror
npm install
pm2 restart magicmirror  # If using PM2
```

### Update System
```bash
sudo apt update && sudo apt upgrade -y
```

## 💾 Backup

### Backup Configuration
```bash
cp ~/MagicMirror/MagicMirror/config/config.js ~/config_backup.js
```

### Backup Entire SD Card
From another computer:
```bash
sudo dd if=/dev/sdX of=~/magicmirror_backup.img bs=4M status=progress
```

## 📈 Monitoring

### Check Status
```bash
pm2 status                    # PM2 status
pm2 logs magicmirror         # View logs
htop                         # System resources
vcgencmd measure_temp        # Temperature
free -h                      # Memory usage
```

### Temperature Monitoring
```bash
watch -n 1 vcgencmd measure_temp
```
Keep below 80°C for optimal performance

## 🎯 Optimization Tips

### 1. Minimal Configuration
Use only essential modules:
- Clock
- Weather (current only)
- Compliments
- News (1 feed)

### 2. Disable Animations
```javascript
animationSpeed: 0,
fadeSpeed: 0
```

### 3. Increase Update Intervals
```javascript
updateInterval: 600000,  // 10 minutes
reloadInterval: 600000,
```

### 4. Use Server Mode
Better performance than full Electron mode

### 5. Overclock (Advanced)
```bash
sudo nano /boot/config.txt
# Add:
over_voltage=2
arm_freq=1350
```
⚠️ Requires good cooling!

## 🌡️ Cooling

For 24/7 operation, consider:
- Heatsinks on CPU
- Small fan (5V)
- Good ventilation
- Monitor temperature regularly

## 🔌 Power Management

### Auto-start on Boot
Already configured with PM2 if you chose that option during installation

### Display Control
Turn off display at night:
```bash
crontab -e
```
Add:
```
0 23 * * * vcgencmd display_power 0  # Off at 11 PM
0 7 * * * vcgencmd display_power 1   # On at 7 AM
```

## 📚 Additional Resources

- **MagicMirror Forum**: https://forum.magicmirror.builders/
- **Module Repository**: https://github.com/MagicMirrorOrg/MagicMirror/wiki/3rd-party-modules
- **Raspberry Pi Docs**: https://www.raspberrypi.org/documentation/
- **This Project**: https://github.com/satyamsingh5512/MagicMirror

## 🆘 Getting Help

1. Check `RASPBERRY_PI_SETUP.md` for detailed guide
2. Check `PI_QUICK_REFERENCE.md` for quick commands
3. Review logs: `pm2 logs magicmirror`
4. Check system: `htop` and `vcgencmd measure_temp`
5. Visit MagicMirror forum

## ✅ Checklist

- [ ] Raspberry Pi 3B with Raspberry Pi OS 64-bit
- [ ] Repository cloned
- [ ] Installation script run (`./install_pi.sh`)
- [ ] Configuration customized
- [ ] Google Gemini API key added (if using AI)
- [ ] Static IP configured (optional)
- [ ] PM2 auto-start configured (optional)
- [ ] Display settings configured
- [ ] Temperature monitoring setup
- [ ] Backup created

## 🎉 You're Ready!

Your MagicMirror is now optimized for Raspberry Pi 3B!

Start it with:
```bash
cd ~/MagicMirror/MagicMirror
npm run server
```

Then access at: `http://[YOUR_PI_IP]:8080`

---

**Need help?** Check the documentation files or visit the MagicMirror forum!

**Last Updated**: 2026-01-03
