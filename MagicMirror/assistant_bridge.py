
import sys
import os
import requests
import json
import threading
import time

# Add the assistant directory to path
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

try:
    from assistant import take_command, speak, model
    print("Assistant modules imported successfully")
except ImportError as e:
    print(f"Error importing assistant modules: {e}")
    sys.exit(1)

class AssistantBridge:
    def __init__(self):
        self.base_url = "http://localhost:5000"
        self.running = True
        
    def send_status(self, status, response=None):
        try:
            data = {"status": status}
            if response:
                data["response"] = response
            requests.post(f"{self.base_url}/assistant/status", json=data, timeout=2)
        except Exception as e:
            print(f"Error sending status: {e}")
    
    def run(self):
        print("Starting AI Assistant Bridge...")
        self.send_status("idle")
        
        while self.running:
            try:
                self.send_status("listening")
                query = take_command()
                
                if query is None:
                    self.send_status("idle")
                    continue
                
                if query in ["exit", "goodbye", "quit", "shutdown"]:
                    speak("Goodbye, shutting down assistant.")
                    self.send_status("idle")
                    break
                
                self.send_status("processing")
                
                if model:
                    try:
                        response = model.generate_content(query)
                        response_text = response.text.replace('*', '')
                        speak(response_text)
                        self.send_status("response", response_text)
                    except Exception as e:
                        error_msg = "Sorry, I encountered an error processing your request."
                        speak(error_msg)
                        self.send_status("response", error_msg)
                        print(f"AI model error: {e}")
                else:
                    error_msg = "AI is currently offline."
                    speak(error_msg)
                    self.send_status("response", error_msg)
                
                time.sleep(1)
                self.send_status("idle")
                
            except KeyboardInterrupt:
                break
            except Exception as e:
                print(f"Error in main loop: {e}")
                self.send_status("idle")
                time.sleep(2)

if __name__ == "__main__":
    bridge = AssistantBridge()
    bridge.run()
