import pandas as pd

from pathlib import Path

root_p = Path("__file__").resolve().parents[1] / 'oasis3'

for p in root_p.glob('**/*'):
    if p.is_file():
        #new_p = Path(str(p).replace("sess", "ses"))
        #new_p = Path(str(p).replace("restingstateMB4", "rest"))
        new_p = Path(str(p).replace("restingstate", "rest"))
        p.rename(new_p)
