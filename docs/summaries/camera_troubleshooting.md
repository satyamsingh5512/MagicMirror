# 📹 Camera Troubleshooting Guide

## Current Status
✅ **MagicMirror**: Running successfully  
✅ **AI Assistant**: Active and listening  
❓ **Camera Feed**: Needs troubleshooting  

## Quick Fixes to Try

### 1. **Check Browser Access**
Open your browser to `http://localhost:8080` and:
- Look for the AI Assistant widget in the top-right corner
- Click the "📹 Start Camera" button if visible
- Grant camera permissions when prompted

### 2. **Test Camera Independently**
Open `http://localhost:8080/camera_test.html` to test camera access separately

### 3. **Browser Console Debug**
1. Open browser developer tools (F12)
2. Go to Console tab
3. Copy and paste the contents of `debug_camera.js`
4. Check for any error messages

## Common Issues & Solutions

### Issue 1: "Camera access denied"
**Solution**: 
- Click the camera icon in browser address bar
- Select "Always allow" for camera access
- Refresh the page

### Issue 2: "getUserMedia not supported"
**Solution**:
- Use a modern browser (Chrome, Firefox, Safari, Edge)
- Ensure you're accessing via `http://localhost:8080` (not file://)

### Issue 3: Camera not showing in MagicMirror
**Possible causes**:
- Module not loaded properly
- DOM timing issues
- Browser security restrictions

**Solutions**:
1. **Check module loading**:
   ```bash
   # Check if module files exist
   ls -la MagicMirror/modules/MMM-AIAssistant/
   ```

2. **Verify config**:
   ```javascript
   // In config/config.js, ensure:
   {
       module: "MMM-AIAssistant",
       position: "top_right",
       config: {
           showCamera: true,  // Must be true
           cameraWidth: 320,
           cameraHeight: 240
       }
   }
   ```

3. **Manual camera start**:
   - Look for the "📹 Start Camera" button in the widget
   - Click it to manually initialize camera

### Issue 4: HTTPS Required
Some browsers require HTTPS for camera access.

**Solution**: Set up HTTPS in MagicMirror config:
```javascript
useHttps: true,
httpsPrivateKey: "path/to/private.key",
httpsCertificate: "path/to/certificate.crt"
```

## Debug Steps

### Step 1: Verify Module Loading
```bash
# Check MagicMirror logs
tail -f ~/.pm2/logs/MagicMirror-out.log
```

### Step 2: Browser Console Check
Open browser console and look for:
- "MMM-AIAssistant: DOM created"
- "Initializing camera..."
- "Camera stream obtained successfully"

### Step 3: Test Camera Permissions
```javascript
// Run in browser console
navigator.mediaDevices.getUserMedia({video: true})
  .then(stream => {
    console.log("Camera works!", stream);
    stream.getTracks().forEach(track => track.stop());
  })
  .catch(err => console.error("Camera error:", err));
```

## Alternative Solutions

### Option 1: Use External Camera Feed
If local camera doesn't work, you can modify the module to use an IP camera:

```javascript
// In MMM-AIAssistant.js, replace video element with:
const img = document.createElement("img");
img.src = "http://your-ip-camera-url/stream";
img.width = this.config.cameraWidth;
img.height = this.config.cameraHeight;
```

### Option 2: Disable Camera Temporarily
```javascript
// In config.js
config: {
    showCamera: false,  // Disable camera for now
    // ... other options
}
```

### Option 3: Use Different Browser
Try different browsers in this order:
1. **Chrome** (best WebRTC support)
2. **Firefox** (good privacy controls)
3. **Edge** (Windows integration)
4. **Safari** (macOS only)

## Expected Behavior

When working correctly, you should see:
1. **AI Assistant widget** in top-right corner
2. **Live camera feed** (320x240 pixels)
3. **Status indicators** (🎤 listening, 🧠 processing, 🤖 idle)
4. **Voice responses** both spoken and displayed as text

## Next Steps

1. **Try the manual camera button** first
2. **Check browser console** for errors
3. **Test with camera_test.html** page
4. **Grant all permissions** when prompted
5. **Try different browser** if needed

## Contact Info

If camera still doesn't work:
- Check browser compatibility
- Verify camera hardware is working
- Try the debug script in browser console
- Consider using external camera feed as alternative

The AI assistant will work perfectly even without camera - the camera is just a nice visual addition! 🎯