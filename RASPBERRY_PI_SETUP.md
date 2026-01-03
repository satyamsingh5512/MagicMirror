# MagicMirror Setup for Raspberry Pi 3B (aarch64)

## Hardware Specifications
- **Model**: Raspberry Pi 3B
- **Architecture**: aarch64 (ARM64)
- **RAM**: 1GB
- **Recommended OS**: Raspberry Pi OS Lite (64-bit) or Raspberry Pi OS with Desktop

## Prerequisites

### 1. Operating System
Install Raspberry Pi OS (64-bit):
```bash
# Check your architecture
uname -m
# Should output: aarch64
```

### 2. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Install Required Packages
```bash
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
```

### 4. Install Node.js 18+ (if not already installed)
```bash
# Check Node version
node -v

# If version is less than 18, install newer version:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify
node -v  # Should be 20.x or higher
npm -v
```

## Installation Steps

### 1. Clone the Repository
```bash
cd ~
git clone https://github.com/satyamsingh5512/MagicMirror.git
cd MagicMirror
```

### 2. Install MagicMirror Dependencies
```bash
cd MagicMirror
npm install --no-audit --no-fund --no-update-notifier
```

**Note**: This may take 10-20 minutes on Raspberry Pi 3B due to limited resources.

### 3. Setup Python Environment for AI Assistant
```bash
# Create virtual environment
python3 -m venv assistant_env

# Activate it
source assistant_env/bin/activate

# Install Python dependencies
pip3 install --upgrade pip
pip3 install google-generativeai requests flask

# Deactivate for now
deactivate
```

### 4. Configure for Raspberry Pi

Edit `MagicMirror/config/config.js`:

```javascript
let config = {
    address: "0.0.0.0",  // Allow access from network
    port: 8080,
    ipWhitelist: [],  // Allow all IPs (or specify your network)
    
    // Optimize for Pi 3B
    electronOptions: {
        webPreferences: {
            zoomFactor: 1.0,
            nodeIntegration: false,
            contextIsolation: true
        }
    },
    
    // Rest of your config...
};
```

### 5. Get Google Gemini API Key

1. Visit: https://makersuite.google.com/app/apikey
2. Create a new API key
3. Add to `MagicMirror/assistant_bridge_simple.py`:

```python
api_key = os.getenv('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
```

Or set environment variable:
```bash
echo 'export GOOGLE_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

## Performance Optimization for Pi 3B

### 1. Reduce Module Load
The Pi 3B has limited RAM (1GB). Consider disabling some modules:

```javascript
// In config/config.js, comment out heavy modules:
modules: [
    // Keep essential modules only
    { module: "clock", position: "top_left" },
    { module: "weather", position: "top_right" },
    { module: "compliments", position: "lower_third" },
    // Disable or reduce:
    // - Multiple news feeds (keep 1-2)
    // - Calendar (if not needed)
    // - AI Assistant (if camera not available)
]
```

### 2. Optimize Electron
Create `MagicMirror/.electron-flags`:
```bash
--disable-gpu
--disable-software-rasterizer
--disable-dev-shm-usage
--no-sandbox
```

### 3. Increase Swap Space (Recommended)
```bash
# Edit swap config
sudo nano /etc/dphys-swapfile

# Change CONF_SWAPSIZE to 2048
CONF_SWAPSIZE=2048

# Restart swap
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### 4. Disable Unnecessary Services
```bash
# Disable Bluetooth if not needed
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth

# Disable WiFi if using Ethernet
sudo rfkill block wifi
```

## Running MagicMirror on Pi

### Method 1: Manual Start
```bash
cd ~/MagicMirror/MagicMirror
npm start
```

### Method 2: Using Startup Script
```bash
cd ~/MagicMirror
./run_magicmirror.sh
```

### Method 3: Server Only Mode (Recommended for Pi 3B)
Run MagicMirror as a server and access via browser:

```bash
cd ~/MagicMirror/MagicMirror
npm run server
```

Then open browser on Pi or another device:
```
http://[PI_IP_ADDRESS]:8080
```

### Method 4: Auto-start on Boot
```bash
# Install PM2
sudo npm install -g pm2

# Start MagicMirror with PM2
cd ~/MagicMirror/MagicMirror
pm2 start npm --name "magicmirror" -- start

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
# Follow the command it outputs

# Check status
pm2 status
pm2 logs magicmirror
```

## Camera Setup (for AI Assistant)

### 1. Enable Camera
```bash
sudo raspi-config
# Navigate to: Interface Options > Camera > Enable
# Reboot
sudo reboot
```

### 2. Test Camera
```bash
# Install camera tools
sudo apt install -y v4l-utils

# List cameras
v4l2-ctl --list-devices

# Test camera
raspistill -o test.jpg
```

### 3. Install OpenCV (Optional, for face detection)
```bash
# This takes a LONG time on Pi 3B (1-2 hours)
pip3 install opencv-python-headless
```

## Display Configuration

### For HDMI Display
```bash
# Edit boot config
sudo nano /boot/config.txt

# Add/modify these lines:
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82  # 1920x1080 60Hz
hdmi_drive=2

# Reboot
sudo reboot
```

### Rotate Display (if needed)
```bash
# In /boot/config.txt
display_rotate=1  # 90 degrees
display_rotate=2  # 180 degrees
display_rotate=3  # 270 degrees
```

## Troubleshooting

### Issue: Out of Memory
**Solution**: 
- Increase swap space (see above)
- Reduce number of modules
- Use server-only mode
- Close other applications

### Issue: Electron Won't Start
**Solution**:
```bash
# Use server mode instead
cd ~/MagicMirror/MagicMirror
npm run server

# Access via browser at http://localhost:8080
```

### Issue: Slow Performance
**Solution**:
- Disable animations in config:
```javascript
config: {
    animationSpeed: 0,
    fadeSpeed: 0
}
```
- Reduce update intervals
- Use fewer modules

### Issue: Camera Not Working
**Solution**:
```bash
# Check camera is enabled
vcgencmd get_camera

# Should output: supported=1 detected=1

# Check permissions
sudo usermod -a -G video $USER
# Logout and login again
```

### Issue: Network Access Not Working
**Solution**:
```bash
# Find Pi's IP address
hostname -I

# Make sure config.js has:
address: "0.0.0.0",
ipWhitelist: [],

# Check firewall
sudo ufw status
# If active, allow port 8080:
sudo ufw allow 8080
```

## Performance Benchmarks (Pi 3B)

| Configuration | RAM Usage | CPU Usage | Startup Time |
|--------------|-----------|-----------|--------------|
| Full (All modules) | ~800MB | 60-80% | 45-60s |
| Optimized (5 modules) | ~500MB | 40-60% | 30-45s |
| Server Only | ~400MB | 30-50% | 20-30s |

## Recommended Configuration for Pi 3B

```javascript
let config = {
    address: "0.0.0.0",
    port: 8080,
    ipWhitelist: [],
    
    language: "en",
    locale: "en-IN",
    timeZone: "Asia/Kolkata",
    timeFormat: 24,
    units: "metric",
    
    modules: [
        {
            module: "clock",
            position: "top_left",
            config: {
                displaySeconds: false,  // Reduce updates
                showDate: true
            }
        },
        {
            module: "weather",
            position: "top_right",
            config: {
                weatherProvider: "openmeteo",
                type: "current",
                lat: 19.3149,
                lon: 84.7941,
                updateInterval: 600000  // 10 minutes
            }
        },
        {
            module: "compliments",
            position: "lower_third"
        },
        {
            module: "newsfeed",
            position: "bottom_bar",
            config: {
                feeds: [
                    {
                        title: "Times of India",
                        url: "https://timesofindia.indiatimes.com/rssfeedstopstories.cms"
                    }
                ],
                updateInterval: 600000,  // 10 minutes
                animationSpeed: 0  // Disable animations
            }
        }
    ]
};
```

## Useful Commands

```bash
# Check system resources
htop

# Check temperature
vcgencmd measure_temp

# Check memory
free -h

# Check disk space
df -h

# View MagicMirror logs
pm2 logs magicmirror

# Restart MagicMirror
pm2 restart magicmirror

# Stop MagicMirror
pm2 stop magicmirror
```

## Power Management

### Auto-start Display on Boot
```bash
# Edit autostart
mkdir -p ~/.config/lxsession/LXDE-pi
nano ~/.config/lxsession/LXDE-pi/autostart

# Add these lines:
@xset s off
@xset -dpms
@xset s noblank
@chromium-browser --kiosk --app=http://localhost:8080
```

### Screen Blanking Control
```bash
# Disable screen blanking
sudo nano /etc/lightdm/lightdm.conf

# Add under [Seat:*]:
xserver-command=X -s 0 -dpms
```

## Network Setup

### Static IP (Recommended)
```bash
sudo nano /etc/dhcpcd.conf

# Add at the end:
interface eth0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=8.8.8.8 8.8.4.4

# Restart networking
sudo systemctl restart dhcpcd
```

## Backup and Recovery

### Backup Configuration
```bash
# Backup config
cp ~/MagicMirror/MagicMirror/config/config.js ~/config_backup.js

# Backup entire SD card (from another computer)
sudo dd if=/dev/sdX of=~/magicmirror_backup.img bs=4M status=progress
```

## Additional Resources

- **MagicMirror Forum**: https://forum.magicmirror.builders/
- **Raspberry Pi Documentation**: https://www.raspberrypi.org/documentation/
- **Module Repository**: https://github.com/MagicMirrorOrg/MagicMirror/wiki/3rd-party-modules

## Support

If you encounter issues:
1. Check logs: `pm2 logs magicmirror`
2. Check system resources: `htop`
3. Check temperature: `vcgencmd measure_temp`
4. Review `PROJECT_STATUS.md` for troubleshooting

---

**Last Updated**: 2026-01-03
**Tested On**: Raspberry Pi 3B (aarch64) with Raspberry Pi OS 64-bit
