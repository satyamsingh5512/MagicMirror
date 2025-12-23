FROM python:3.11-slim

# Install system dependencies for PyAudio and TTS
RUN apt-get update && apt-get install -y \
    gcc \
    libasound2-dev \
    portaudio19-dev \
    libportaudio2 \
    libffi-dev \
    espeak \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
    SpeechRecognition \
    pyttsx3 \
    pyaudio \
    google-generativeai

# Copy your assistant script
COPY assistant.py /assistant.py
CMD ["python3", "/assistant.py"]
