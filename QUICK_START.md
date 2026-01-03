# MagicMirror Quick Start Guide

## Prerequisites

- Node.js 18+ (22+ recommended)
- npm
- Linux with X11 or Wayland display server

## Quick Start

### 1. Run MagicMirror

```bash
./run_magicmirror.sh
```

This script will:
- Check if all dependencies are installed
- Verify your configuration
- Start MagicMirror

### 2. Alternative: Manual Start

```bash
cd MagicMirror
npm start
```

### 3. Development Mode (with DevTools)

```bash
cd MagicMirror
npm run start:dev
```

## Configuration

Your configuration is located at: `MagicMirror/config/config.js`

### Key Settings

- **Address**: `localhost` (change to `0.0.0.0` for network access)
- **Port**: `8080`
- **Language**: `en` (English)
- **Locale**: `en-IN` (Indian English)
- **Timezone**: `Asia/Kolkata` (IST)

## Modules Included

1. **Clock** - Shows current time and date
2. **Calendar** - Displays Indian holidays
3. **Weather** - Current weather and forecast for Berhampur
4. **News Feed** - Indian and Odisha news
5. **Compliments** - Random compliments
6. **MMM-AIAssistant** - AI assistant with camera and face detection

## AI Assistant Setup

The AI Assistant requires a Google Gemini API key.

### Get Your API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Update the key in: `MagicMirror/assistant_bridge_simple.py`

```python
api_key = os.getenv('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
```

### Start the AI Assistant

```bash
cd MagicMirror
python3 assistant_bridge_simple.py
```

Or set environment variable:

```bash
export GOOGLE_API_KEY="your-api-key-here"
python3 assistant_bridge_simple.py
```

## Troubleshooting

### Blank Screen

1. Open DevTools (F12 or Ctrl+Shift+I)
2. Check Console for errors
3. Verify all files are present:
   ```bash
   cd MagicMirror
   ls -la js/logger.js js/positions.js
   ```

### Module Not Loading

Check the terminal output for errors. Common issues:
- Missing dependencies: Run `npm install` in MagicMirror directory
- Config syntax error: Check `config/config.js`

### Port Already in Use

Change the port in `config/config.js`:

```javascript
port: 8081,  // Change from 8080
```

## Server Only Mode

To run without Electron (headless):

```bash
cd MagicMirror
npm run server
```

Then access via browser: `http://localhost:8080`

## Stopping MagicMirror

Press `Ctrl+C` in the terminal where MagicMirror is running.

## Project Structure

```
.
├── MagicMirror/              # Main MagicMirror application
│   ├── config/               # Configuration files
│   ├── modules/              # Modules (default + custom)
│   │   └── MMM-AIAssistant/  # AI Assistant module
│   ├── js/                   # Core JavaScript files
│   ├── css/                  # Stylesheets
│   └── assistant_bridge_simple.py  # AI Assistant backend
├── run_magicmirror.sh        # Quick start script
└── QUICK_START.md            # This file
```

## Need Help?

- Check logs in the terminal
- Open DevTools (F12) for browser errors
- Review `INSTALLATION_SUMMARY.md` for detailed setup
