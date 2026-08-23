#!/usr/bin/env python3
"""
Simpler approach - convert audio to WAV and analyze with scipy only
"""
import json
import sys
import subprocess
import wave
import struct

audio_path = r"c:/Users/LucasJoaquimDaSilva/Documents/Casamento/assets/audio/anjos_cantam.m4a"
wav_path = r"c:/Users/LucasJoaquimDaSilva/Documents/Casamento/convite/temp_audio.wav"

print("Convertendo para WAV...")
try:
    subprocess.run(["ffmpeg", "-i", audio_path, "-q:a", "9", "-n", wav_path], 
                   capture_output=True, check=False, timeout=60)
except Exception as e:
    print(f"ffmpeg não disponível: {e}")
    sys.exit(1)

print("Lendo dados de áudio...")
with wave.open(wav_path, 'rb') as wav_file:
    n_channels = wav_file.getnchannels()
    sample_width = wav_file.getsampwidth()
    frame_rate = wav_file.getframerate()
    n_frames = wav_file.getnframes()
    
    data = wav_file.readframes(n_frames)
    
duration = n_frames / frame_rate
print(f"Duração: {duration:.2f}s, Taxa: {frame_rate}Hz, Canais: {n_channels}")

# Converter bytes para números
if sample_width == 2:
    samples = struct.unpack('<' + 'h' * (len(data) // 2), data)
else:
    samples = struct.unpack('<' + 'B' * len(data), data)

# Se estéreo, usar apenas o primeiro canal
if n_channels > 1:
    samples = [samples[i] for i in range(0, len(samples), n_channels)]

# Normalizar
max_val = max(abs(x) for x in samples) or 1
normalized = [float(x) / max_val for x in samples]

# Aplicar low-pass filter simples (para detectar batidas/bass)
hop_length = frame_rate // 50  # ~20ms frames
bass_energy = []

for i in range(0, len(normalized) - hop_length, hop_length):
    chunk = normalized[i:i + hop_length]
    energy = sum(abs(x) for x in chunk) / len(chunk)
    bass_energy.append(energy)

# Detectar picos
threshold = sum(bass_energy) / len(bass_energy) + 0.1 * max(bass_energy)
peaks = []

for i in range(1, len(bass_energy) - 1):
    if (bass_energy[i] > threshold and 
        bass_energy[i] > bass_energy[i-1] and 
        bass_energy[i] > bass_energy[i+1]):
        time = i * hop_length / frame_rate
        energy = min(1.0, bass_energy[i] / max(bass_energy))
        peaks.append({'time': round(time, 2), 'energy': round(energy, 2)})

# Remover duplicados muito próximos
filtered = []
for peak in peaks:
    if not filtered or peak['time'] - filtered[-1]['time'] > 0.1:
        filtered.append(peak)

print(f"Detectados {len(filtered)} picos de batida")
print(f"Amostra dos picos:")
for p in filtered[:10]:
    print(f"  {p['time']:.2f}s - {p['energy']:.2f}")

# Gerar JavaScript
js_code = f"  var beatPattern = {json.dumps(filtered)};\n"
js_code += f"  var beatCycleLength = {duration:.2f}; // duração exata da música\n"

output_file = r"c:/Users/LucasJoaquimDaSilva/Documents/Casamento/convite/beat_data.js"
with open(output_file, 'w') as f:
    f.write(js_code)

print(f"✅ Salvo em beat_data.js")

# Limpar WAV temporário
import os
try:
    os.remove(wav_path)
except:
    pass

