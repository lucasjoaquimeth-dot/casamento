import re, sys, os

files = ['convite_v1_aquarela.html','convite_v2_luxo.html','convite_v3_botanico.html','convite_v4_noturno.html']
os.makedirs('tools/stripped', exist_ok=True)
for f in files:
    s = open(f, encoding='utf-8').read()
    n = len(re.findall(r'data:image', s))
    s2 = re.sub(r'data:image/[a-zA-Z+]+;base64,[A-Za-z0-9+/=\s]+', 'DATA_URI_REMOVED', s)
    out = 'tools/stripped/' + f
    open(out, 'w', encoding='utf-8').write(s2)
    print(f, len(s), '->', len(s2), 'datauris:', n, 'lines:', s2.count('\n'))
