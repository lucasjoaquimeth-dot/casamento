"""Prepara os assets otimizados usados pelos convites.

Gera em assets/build/:
  flor_spray.png   -> ramo horizontal recortado no bbox alpha (moldura topo/base)
  flor_canto.png   -> metade do ramo, para usar em cantos
  fundo.jpg        -> fundo vale verde otimizado
"""
from PIL import Image, ImageFilter
import numpy as np
import os

SRC = 'assets'
OUT = os.path.join(SRC, 'build')
os.makedirs(OUT, exist_ok=True)


def alpha_bbox(img):
    a = np.array(img.split()[-1])
    ys, xs = np.where(a > 6)
    return (xs.min(), ys.min(), xs.max() + 1, ys.max() + 1)


def main():
    flor = Image.open(os.path.join(SRC, 'flor_sem_fundo.png')).convert('RGBA')
    flor = flor.crop(alpha_bbox(flor))

    # remove franjas: alpha muito baixo virou 0, borda ganha leve suavizacao
    d = np.array(flor)
    a = d[:, :, 3].astype(np.float32)
    a[a < 18] = 0
    d[:, :, 3] = a.astype(np.uint8)
    flor = Image.fromarray(d, 'RGBA')
    alpha = flor.split()[-1].filter(ImageFilter.GaussianBlur(0.6))
    flor.putalpha(alpha)

    spray = flor.copy()
    spray.thumbnail((1100, 1100), Image.LANCZOS)
    spray.save(os.path.join(OUT, 'flor_spray.png'), optimize=True)

    # canto: metade esquerda do ramo (ponta fina para dentro)
    w, h = flor.size
    canto = flor.crop((0, 0, int(w * 0.56), h))
    canto = canto.crop(alpha_bbox(canto))
    canto.thumbnail((760, 760), Image.LANCZOS)
    canto.save(os.path.join(OUT, 'flor_canto.png'), optimize=True)

    fundo = Image.open(os.path.join(SRC, 'vale_verde_fundo.png')).convert('RGB')
    fundo = fundo.resize((900, int(900 * fundo.height / fundo.width)), Image.LANCZOS)
    fundo = fundo.filter(ImageFilter.GaussianBlur(2.2))
    fundo.save(os.path.join(OUT, 'fundo.jpg'), quality=72, optimize=True, progressive=True)

    for f in sorted(os.listdir(OUT)):
        p = os.path.join(OUT, f)
        print(f, Image.open(p).size, f'{os.path.getsize(p):,} bytes')


if __name__ == '__main__':
    main()
