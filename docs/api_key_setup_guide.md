# 🔑 Google Gemini API Key Setup Guide

## 🚨 **Current Issue**

**Error**: `429 You exceeded your current quota`
- **Cause**: The embedded API key has reached its free tier limits
- **Impact**: AI responses are using fallback mode
- **Solution**: Get your own free Google Gemini API key

## ✅ **Quick Fix - Get Your Own API Key**

### **Step 1: Visit Google AI Studio**
1. Go to: https://makersuite.google.com/app/apikey
2. Or: https://aistudio.google.com/app/apikey
3. Sign in with your Google account

### **Step 2: Create API Key**
1. Click **"Create API Key"** button
2. Select **"Create API key in new project"** (recommended)
3. Copy the generated API key (starts with `AIza...`)
4. **Important**: Save it securely - you won't see it again!

### **Step 3: Update MagicMirror**
Replace the API key in the assistant bridge file:

```bash
# Edit the file
nano ~/Documents/projects/Magicmirror/MagicMirror/assistant_bridge_simple.py

# Find this line (around line 19):
api_key = 'YOUR_API_KEY_HERE'

# Replace with your new key:
api_key = 'YOUR_NEW_API_KEY_HERE'

# Save and exit (Ctrl+X, Y, Enter)
```

### **Step 4: Restart MagicMirror**
```bash
# Stop current instance (Ctrl+C in terminal)
# Or restart from Kiro

# Start again
cd ~/Documents/projects/Magicmirror/MagicMirror
npm start
```

## 📊 **Free Tier Limits**

### **Google Gemini Free Tier**
- **Requests per minute**: 15 requests
- **Requests per day**: 1,500 requests
- **Tokens per minute**: 1 million tokens
- **Cost**: **FREE** ✨

### **Usage Tips**
- **Demo mode**: Uses ~5 requests per cycle
- **Interactive mode**: 1 request per query
- **Rate limiting**: Built-in delays prevent quota issues
- **Fallback**: Automatic fallback when quota exceeded

## 🔄 **Current Fallback System**

While waiting for a new API key, the system provides intelligent fallback responses:

### **Supported Queries**
- **Time**: "What time is it?" → Shows current time
- **Weather**: "How's the weather?" → Points to weather widget
- **News**: "What's in the news?" → Points to news feed
- **Jokes**: "Tell me a joke" → Pre-programmed jokes
- **Help**: "What can you do?" → Lists capabilities
- **General**: Any other query → Helpful fallback message

### **Example Fallback Responses**
```
User: "What time is it?"
AI: "The current time is 11:30 PM. I'm running in fallback mode without AI API access."

User: "Tell me about the weather"
AI: "Check the weather widget on your MagicMirror for current conditions in Berhampur, Odisha!"

User: "Tell me a joke"
AI: "Why did the smart mirror go to therapy? Because it had too many reflections! 😄"
```

## 🎯 **Alternative AI Options**

### **Option 1: Use Different Gemini Model**
The system automatically tries these models in order:
1. `gemini-1.5-flash` (newest, faster)
2. `gemini-1.0-pro` (stable)
3. `gemini-pro` (fallback)

### **Option 2: Use OpenAI (Future)**
You can modify the code to use OpenAI's API:
- Get API key from: https://platform.openai.com/api-keys
- Models: GPT-3.5-turbo (cheap) or GPT-4 (powerful)
- Cost: Pay-as-you-go pricing

### **Option 3: Local AI (Advanced)**
Run AI locally without API:
- **Ollama**: Free, runs on your computer
- **LM Studio**: User-friendly local AI
- **Models**: Llama 2, Mistral, etc.

## 🛠️ **Troubleshooting**

### **"Still getting quota errors"**
- Wait 24 hours for quota reset
- Check API key is correctly copied
- Verify no extra spaces in API key
- Try a different Google account

### **"API key not working"**
- Ensure API key is enabled
- Check Google Cloud Console for restrictions
- Verify billing is set up (even for free tier)
- Try regenerating the API key

### **"Want to test without API"**
The fallback system works perfectly for testing:
- All UI features work
- Status indicators function
- Responses are contextual
- No API key needed

## 📝 **Security Best Practices**

### **Protect Your API Key**
- ❌ **Don't**: Share publicly or commit to GitHub
- ❌ **Don't**: Use in client-side code
- ✅ **Do**: Keep in server-side files only
- ✅ **Do**: Use environment variables (advanced)
- ✅ **Do**: Regenerate if exposed

### **Environment Variable Setup** (Optional)
```bash
# Create .env file
echo "GEMINI_API_KEY=your_key_here" > ~/Documents/projects/Magicmirror/MagicMirror/.env

# Update Python code to read from .env
# (requires python-dotenv package)
```

## 🎊 **Success Checklist**

- [ ] Visited Google AI Studio
- [ ] Created new API key
- [ ] Copied API key securely
- [ ] Updated assistant_bridge_simple.py
- [ ] Restarted MagicMirror
- [ ] Tested AI responses
- [ ] Verified quota is working

## 🚀 **Next Steps**

1. **Get your API key** (5 minutes)
2. **Update the code** (2 minutes)
3. **Restart MagicMirror** (1 minute)
4. **Enjoy unlimited AI** (free tier: 1,500 requests/day)

Your MagicMirror will work perfectly with fallback responses until you add your own API key! 🎯✨