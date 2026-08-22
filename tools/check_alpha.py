from PIL import Image
import numpy as np

img = Image.open('assets/flor_sem_fundo.png').convert('RGBA')
d = np.array(img)

print('=== Alpha nas bordas (0 = transparente) ===')
print('Canto TL:', d[0,0,3], d[5,5,3], d[10,10,3])
print('Canto TR:', d[0,-1,3], d[5,-5,3])
print('Canto BL:', d[-1,0,3], d[-5,5,3])
print('Canto BR:', d[-1,-1,3], d[-5,-5,3])

total = d.shape[0] * d.shape[1]
transp = (d[:,:,3] == 0).sum()
semitransp = ((d[:,:,3] > 0) & (d[:,:,3] < 255)).sum()
opaco = (d[:,:,3] == 255).sum()
print(f'\nTotal pixels: {total:,}')
print(f'Transparentes (alpha=0):   {transp:,}  ({transp/total*100:.1f}%)')
print(f'Semi-transparentes (borda): {semitransp:,}  ({semitransp/total*100:.1f}%)')
print(f'Opacos (alpha=255):        {opaco:,}  ({opaco/total*100:.1f}%)')
print(f'\nDimensoes: {img.size}')
print(f'Mode: {img.mode}')
