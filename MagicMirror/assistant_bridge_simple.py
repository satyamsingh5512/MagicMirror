#!/usr/bin/env python3

import sys
import os
import requests
import json
import time
import threading
from datetime import datetime

# Add the assistant directory to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

# Try to import assistant modules with fallback
try:
    import google.generativeai as genai
    
    # Configure AI with fallback
    api_key = os.getenv('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')  # Set your API key here or use environment variable
    
    # Try multiple models and fallbacks
    model = None
    ai_type = "none"
    
    if api_key:
        try:
            genai.configure(api_key=api_key)
            # Try different models in order of preference
            models_to_try = ["gemini-1.5-flash", "gemini-1.0-pro", "gemini-pro"]
            
            for model_name in models_to_try:
                try:
                    model = genai.GenerativeModel(model_name)
                    # Test with a simple query
                    test_response = model.generate_content("Hello")
                    ai_type = f"gemini-{model_name}"
                    print(f"Google Gemini AI configured successfully with {model_name}")
                    break
                except Exception as e:
                    print(f"Failed to use {model_name}: {e}")
                    continue
                    
        except Exception as e:
            print(f"Error configuring Gemini AI: {e}")
            model = None
    
    if not model:
        ai_type = "fallback"
        print("Using fallback AI responses (no API available)")
        
except ImportError as e:
    print(f"Error importing AI modules: {e}")
    model = None

class AssistantBridge:
    def __init__(self):
        self.base_url = "http://localhost:5000"
        self.running = True
        self.demo_mode = True  # For testing without microphone
        self.fallback_responses = {
            "time": "The current time is {time}. I'm running in fallback mode without AI API access.",
            "weather": "I can see you're asking about weather. Check the weather widget on your MagicMirror for current conditions in Berhampur, Odisha!",
            "news": "For the latest news, check the news feed at the bottom of your MagicMirror. It shows updates from Times of India, The Hindu, and Odisha TV.",
            "joke": "Why did the smart mirror go to therapy? Because it had too many reflections! 😄 (Fallback joke - AI API quota exceeded)",
            "help": "I'm your AI assistant! I can help with questions about time, weather, news, and general queries. Currently running in fallback mode due to API limits.",
            "default": "I understand you're asking: '{query}'. I'm currently in fallback mode as the AI API quota has been exceeded. Please check back later or get a new API key!"
        }
        
    def send_status(self, status, response=None):
        try:
            data = {"status": status}
            if response:
                data["response"] = response
            requests.post(f"{self.base_url}/assistant/status", json=data, timeout=2)
            print(f"Status sent: {status}")
        except Exception as e:
            print(f"Error sending status: {e}")
    
    def get_fallback_response(self, query):
        """Generate intelligent fallback responses when AI API is unavailable"""
        query_lower = query.lower()
        current_time = datetime.now().strftime("%I:%M %p")
        
        if any(word in query_lower for word in ["time", "clock", "hour"]):
            return self.fallback_responses["time"].format(time=current_time)
        elif any(word in query_lower for word in ["weather", "temperature", "rain", "sunny"]):
            return self.fallback_responses["weather"]
        elif any(word in query_lower for word in ["news", "headlines", "updates"]):
            return self.fallback_responses["news"]
        elif any(word in query_lower for word in ["joke", "funny", "laugh"]):
            return self.fallback_responses["joke"]
        elif any(word in query_lower for word in ["help", "what can you", "capabilities"]):
            return self.fallback_responses["help"]
        else:
            return self.fallback_responses["default"].format(query=query)
    
    def demo_interaction(self):
        """Demo mode for testing without microphone"""
        demo_queries = [
            "What time is it?",
            "Tell me about the weather",
            "What's happening in the news?",
            "Tell me a joke",
            "What can you help me with?"
        ]
        
        for i, query in enumerate(demo_queries):
            print(f"\n--- Demo Query {i+1}: {query} ---")
            
            self.send_status("listening")
            time.sleep(2)
            
            self.send_status("processing")
            time.sleep(1)
            
            if model:
                try:
                    response = model.generate_content(query)
                    response_text = response.text.replace('*', '').strip()
                    print(f"AI Response: {response_text}")
                    self.send_status("response", response_text)
                except Exception as e:
                    if "quota" in str(e).lower() or "429" in str(e):
                        print("API quota exceeded, using fallback response")
                        fallback_response = self.get_fallback_response(query)
                        print(f"Fallback Response: {fallback_response}")
                        self.send_status("response", fallback_response)
                    else:
                        error_msg = f"AI Error: {str(e)[:100]}..."
                        print(error_msg)
                        self.send_status("response", error_msg)
            else:
                fallback_response = self.get_fallback_response(query)
                print(f"Fallback Response: {fallback_response}")
                self.send_status("response", fallback_response)
            
            time.sleep(5)  # Show response for 5 seconds
            self.send_status("idle")
            time.sleep(3)  # Wait before next demo
    
    def interactive_mode(self):
        """Interactive mode for manual testing"""
        print("\n=== Interactive Mode ===")
        print("Type your questions (or 'quit' to exit):")
        
        while self.running:
            try:
                query = input("\nYou: ").strip()
                
                if not query:
                    continue
                    
                if query.lower() in ["quit", "exit", "bye"]:
                    print("Goodbye!")
                    self.send_status("idle")
                    break
                
                self.send_status("listening")
                time.sleep(0.5)
                
                self.send_status("processing")
                
                if model:
                    try:
                        response = model.generate_content(query)
                        response_text = response.text.replace('*', '').strip()
                        print(f"AI: {response_text}")
                        self.send_status("response", response_text)
                    except Exception as e:
                        if "quota" in str(e).lower() or "429" in str(e):
                            fallback_response = self.get_fallback_response(query)
                            print(f"AI (Fallback): {fallback_response}")
                            self.send_status("response", fallback_response)
                        else:
                            error_msg = f"Sorry, I encountered an error: {str(e)[:100]}..."
                            print(f"AI: {error_msg}")
                            self.send_status("response", error_msg)
                else:
                    fallback_response = self.get_fallback_response(query)
                    print(f"AI (Fallback): {fallback_response}")
                    self.send_status("response", fallback_response)
                
                time.sleep(2)
                self.send_status("idle")
                
            except KeyboardInterrupt:
                print("\nExiting...")
                break
            except Exception as e:
                print(f"Error: {e}")
                self.send_status("idle")
    
    def run(self):
        print("=== AI Assistant Bridge Started ===")
        print(f"Time: {datetime.now()}")
        print(f"Model available: {model is not None}")
        print(f"Base URL: {self.base_url}")
        
        # Send initial status
        self.send_status("idle")
        
        # Choose mode based on arguments
        if len(sys.argv) > 1 and sys.argv[1] == "demo":
            print("\n--- Running in DEMO mode ---")
            self.demo_interaction()
        elif len(sys.argv) > 1 and sys.argv[1] == "interactive":
            print("\n--- Running in INTERACTIVE mode ---")
            self.interactive_mode()
        else:
            print("\n--- Running in CONTINUOUS mode ---")
            # Keep running and responding to status requests
            try:
                while self.running:
                    self.send_status("idle")
                    time.sleep(5)  # Send heartbeat every 5 seconds
            except KeyboardInterrupt:
                print("\nShutting down...")
                self.send_status("idle")

if __name__ == "__main__":
    bridge = AssistantBridge()
    bridge.run()