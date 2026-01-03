# Raspberry Pi 3B Quick Reference

## Installation (One Command)
```bash
git clone https://github.com/satyamsingh5512/MagicMirror.git
cd MagicMirror
./install_pi.sh
```

## Starting MagicMirror

### Method 1: Full Mode (with Electron)
```bash
cd ~/MagicMirror/MagicMirror
npm start
```

### Method 2: Server Mode (Recommended for Pi 3B)
```bash
cd ~/MagicMirror/MagicMirror
npm run server
```
Access at: `http://[PI_IP]:8080`

### Method 3: Auto-start with PM2
```bash
cd ~/MagicMirror/MagicMirror
pm2 start npm --name magicmirror -- start
pm2 save
pm2 startup  # Follow the command it outputs
```

## Common Commands

### Check Status
```bash
pm2 status                    # Check if running
pm2 logs magicmirror         # View logs
htop                         # System resources
vcgencmd measure_temp        # CPU temperature
```

### Control MagicMirror
```bash
pm2 restart magicmirror      # Restart
pm2 stop magicmirror         # Stop
pm2 delete magicmirror       # Remove from PM2
```

### Update MagicMirror
```bash
cd ~/MagicMirror
git pull origin main
cd MagicMirror
npm install
pm2 restart magicmirror
```

## Configuration Files

| File | Purpose |
|------|---------|
| `MagicMirror/config/config.js` | Main configuration |
| `MagicMirror/config/config_pi3b.js` | Optimized for Pi 3B |
| `MagicMirror/assistant_bridge_simple.py` | AI Assistant backend |

## Network Access

### Find Pi's IP Address
```bash
hostname -I
```

### Access from Another Device
```
http://[PI_IP_ADDRESS]:8080
```

### Set Static IP
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

## Performance Tips

### 1. Use Optimized Config
```bash
cd ~/MagicMirror/MagicMirror/config
cp config_pi3b.js config.js
```

### 2. Reduce Modules
Edit `config/config.js` and comment out unused modules

### 3. Increase Swap
```bash
sudo nano /etc/dphys-swapfile
# Set CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### 4. Disable Animations
In `config.js`:
```javascript
animationSpeed: 0,
fadeSpeed: 0
```

## Troubleshooting

### Out of Memory
```bash
# Check memory
free -h

# Increase swap (see above)
# Reduce modules in config.js
```

### Won't Start
```bash
# Check logs
pm2 logs magicmirror

# Try server mode
cd ~/MagicMirror/MagicMirror
npm run server
```

### Slow Performance
```bash
# Check temperature
vcgencmd measure_temp

# Check CPU usage
htop

# Use optimized config
cp config/config_pi3b.js config/config.js
```

### Display Issues
```bash
# Edit boot config
sudo nano /boot/config.txt

# Force HDMI
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82
```

## Camera Setup

### Enable Camera
```bash
sudo raspi-config
# Interface Options > Camera > Enable
sudo reboot
```

### Test Camera
```bash
raspistill -o test.jpg
```

## API Key Setup

### Get API Key
Visit: https://makersuite.google.com/app/apikey

### Add to Config
```bash
nano ~/MagicMirror/MagicMirror/assistant_bridge_simple.py
```
Change line 19:
```python
api_key = os.getenv('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
```

### Or Use Environment Variable
```bash
echo 'export GOOGLE_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

## System Maintenance

### Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### Clean Up
```bash
sudo apt autoremove -y
sudo apt clean
```

### Backup Config
```bash
cp ~/MagicMirror/MagicMirror/config/config.js ~/config_backup.js
```

## Display Control

### Turn Off Display
```bash
vcgencmd display_power 0
```

### Turn On Display
```bash
vcgencmd display_power 1
```

### Auto Turn Off at Night
```bash
crontab -e
```
Add:
```
0 23 * * * vcgencmd display_power 0
0 7 * * * vcgencmd display_power 1
```

## Resource Limits (Pi 3B)

| Resource | Limit | Recommended |
|----------|-------|-------------|
| RAM | 1GB | Use 5-7 modules max |
| CPU | 4 cores @ 1.2GHz | Disable animations |
| Swap | Default 100MB | Increase to 2GB |
| Modules | Unlimited | 5-7 for best performance |

## Recommended Modules for Pi 3B

✅ **Lightweight:**
- clock
- compliments
- weather (current only)
- newsfeed (1-2 feeds)

⚠️ **Medium:**
- calendar (reduce entries)
- weather (with forecast)
- newsfeed (3-4 feeds)

❌ **Heavy (Avoid):**
- MMM-AIAssistant (with camera)
- Multiple calendars
- Many news feeds (5+)
- Video modules

## Getting Help

1. Check logs: `pm2 logs magicmirror`
2. Check temperature: `vcgencmd measure_temp`
3. Check memory: `free -h`
4. Review: `RASPBERRY_PI_SETUP.md`
5. Forum: https://forum.magicmirror.builders/

## Quick Links

- **Documentation**: `RASPBERRY_PI_SETUP.md`
- **Quick Start**: `QUICK_START.md`
- **Status**: `PROJECT_STATUS.md`
- **GitHub**: https://github.com/satyamsingh5512/MagicMirror

---

**Tip**: For best performance on Pi 3B, use server mode and access via browser!
