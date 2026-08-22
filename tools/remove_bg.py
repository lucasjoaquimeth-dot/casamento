from PIL import Image
import numpy as np
import os

img = Image.open('assets/flor.png').convert('RGBA')
data = np.array(img, dtype=np.float32)

r = data[:, :, 0]
g = data[:, :, 1]
b = data[:, :, 2]
a = data[:, :, 3]

# Saturação (quanto de cor vs branco/cinza)
ch_max = np.max(data[:, :, :3], axis=2)
ch_min = np.min(data[:, :, :3], axis=2)
saturation = ch_max - ch_min

# Brilho médio
brightness = (r + g + b) / 3.0

# Estratégia: dois passes
# 1) Fundo puro branco/cinza claro sem saturação → totalmente transparente
# 2) Borda suave: pixels claro-azulados (pétalas translúcidas) → preservados

# Pixels que SÃO fundo: muito claro e quase sem saturação
# threshold mais baixo para apanhar cinzas externos
is_pure_bg = (brightness > 245) & (saturation < 15)

# Zona de transição: claro mas tem alguma cor azulada
# bg_fade: 0 = flor, 1 = fundo puro
bg_fade = np.clip((brightness - 220) / 35.0, 0, 1) * np.clip(1.0 - saturation / 25.0, 0, 1)

# Força alpha=0 no fundo puro, fade suave nas bordas
new_alpha = np.where(is_pure_bg, 0.0, a * (1.0 - bg_fade))

# Segunda passagem: flood-fill simulado — pixels conectados à borda com brightness>220
# São garantidamente fundo externo, não pétala interna
h, w = data.shape[:2]
mask_bg = np.zeros((h, w), dtype=bool)

# Sementes nas 4 bordas
border_seed = np.zeros((h, w), dtype=bool)
border_seed[0, :] = True
border_seed[-1, :] = True
border_seed[:, 0] = True
border_seed[:, -1] = True

# Pixels elegíveis para fundo (claros e pouco saturados)
eligible = (brightness > 215) & (saturation < 35)

# BFS iterativo via dilatação
from scipy.ndimage import binary_dilation
current = border_seed & eligible
for _ in range(300):
    expanded = binary_dilation(current, iterations=1) & eligible
    if not np.any(expanded & ~current):
        break
    current = expanded

# Pixels alcançados pela BFS = fundo externo → alpha 0
new_alpha = np.where(current, 0.0, new_alpha)

# Suavizar bordas restantes (anti-aliasing leve)
data[:, :, 3] = np.clip(new_alpha, 0, 255)

result = Image.fromarray(data.astype(np.uint8), 'RGBA')
result.save('assets/flor_sem_fundo.png', optimize=True)

orig = os.path.getsize('assets/flor.png')
novo = os.path.getsize('assets/flor_sem_fundo.png')
print(f'OK — Original: {orig:,} bytes | Novo: {novo:,} bytes')
print(f'Pixels de fundo removidos (BFS): {current.sum():,}')
