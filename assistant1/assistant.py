import speech_recognition as sr
import os
import pyttsx3
import webbrowser
import datetime
import google.generativeai as genai
import threading
from multiprocessing import Event, Process

# --- AI Configuration ---
api_key = os.getenv("GOOGLE_API_KEY")
# api_key='YOUR_API_KEY_HERE'  # Or set GOOGLE_API_KEY environment variable

if api_key:
    try:
        genai.configure(api_key=api_key)
        model = genai.GenerativeModel("gemini-2.0-flash")
        print("Google Gemini AI configured successfully.")
    except Exception as e:
        print(f"Error configuring Gemini AI: {e}")
        model = None
else:
    print("API key not found. AI features disabled.")
    model = None

# --- Text-to-Speech Engine ---
try:
    engine = pyttsx3.init()
except Exception as e:
    print(f"Error initializing text-to-speech engine: {e}")
    engine = None

# --- Stop Event for Speech Interruption ---
stop_event = Event()

def speak(text):
    """Converts text to speech and stops if 'stop' is detected."""
    if engine:
        print(f"Assistant: {text}")
        engine.say(text)
        engine.runAndWait()
    else:
        print(f"Assistant (TTS disabled): {text}")

def take_command():
    """Listens for a command from the user and returns it as text."""
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("\nListening...")
        r.pause_threshold = 1
        r.adjust_for_ambient_noise(source)  # Adjust for background noise
        try:
            audio = r.listen(source, timeout=5, phrase_time_limit=5)
            print("Recognizing...")
            query = r.recognize_google(audio, language="en-in")
            print(f"User said: {query}")
            return query.lower()
        except sr.UnknownValueError:
            print("Sorry, I did not understand that.")
            return None
        except sr.RequestError as e:
            print(f"Could not request results from Google Speech Recognition service; {e}")
            return None
        except Exception as e:
            print(f"An error occurred: {e}")
            return None

def listen_for_stop():
    """Listens for 'stop' command and interrupts speech."""
    global stop_event
    r = sr.Recognizer()
    with sr.Microphone() as source:
        r.adjust_for_ambient_noise(source)
        try:
            print("Listening for 'stop' command...")
            audio = r.listen(source, timeout=3, phrase_time_limit=3)
            query = r.recognize_google(audio, language="en-in").lower()
            if "stop" in query:
                stop_event.set()
                engine.stop()
                print("Speech interrupted!")
        except Exception:
            pass

def main():
    while True:
        query = take_command()
        if query is None:
            continue

        # Exit command
        if query in ["exit", "goodbye", "quit"]:
            speak("Goodbye, sir. Shutting down.")
            break

        # Check for stop command before speaking
        stop_event.clear()
        listener_thread = threading.Thread(target=listen_for_stop)
        listener_thread.start()

        # AI-powered response
        if model:
            try:
                speak("Thinking...")
                response = model.generate_content(query)
                if not stop_event.is_set():
                    speak(response.text.replace('*', ''))
            except Exception as e:
                print(f"AI model error: {e}")
                speak("Sorry, I encountered an error with the AI model.")
        else:
            speak("I'm not sure how to help with that, and my AI brain is currently offline.")

if __name__ == '__main__':
    process1 = Process(target=listen_for_stop)
    process2 = Process(target=main)

    process1.start()
    process2.start()

    process1.join()
    process2.join()