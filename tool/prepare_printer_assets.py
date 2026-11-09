"""Copy/convert user-supplied product photos; preserve the source folder."""
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / '.dart_tool' / 'asset-conversion'))
from PIL import Image

OUTPUT = ROOT / 'assets' / 'images' / 'printers'
OUTPUT.mkdir(parents=True, exist_ok=True)
SOURCES = {
    '00001-II': 'hp-315',
    '00002-II': 'epson-l3110',
    '00003-II': 'epson-l3160',
    '00004-II': 'hp-515',
}

for folder, name in SOURCES.items():
    for number in range(1, 4):
        extension = 'avif' if folder == '00001-II' else 'jpg'
        source = ROOT / 'PRODUCTOS' / folder / f'{number}.{extension}'
        target = OUTPUT / f'{name}-{number}.jpg'
        if extension == 'jpg':
            shutil.copyfile(source, target)
        else:
            with Image.open(source) as image:
                rgba = image.convert('RGBA')
                canvas = Image.new('RGB', rgba.size, 'white')
                canvas.paste(rgba, mask=rgba.getchannel('A'))
                canvas.save(target, quality=95)
        print(target.relative_to(ROOT))
