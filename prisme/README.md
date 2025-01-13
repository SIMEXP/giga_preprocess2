# PRISME QC and connectome generation

For more info on connectome workflow see the giga-connectome [docs](https://giga-connectome.readthedocs.io/en/latest/usage.html).

1. Run QC (see [repo](https://github.com/SIMEXP/giga_auto_qc))
- `submit_qc.sh`

2. Organise atlases according to TemplateFlow convention
- `ColeAnticevic12.json` & `brainnetome.json`: config files
- `copy_rename_CABNP.py` & `copy_rename_BA.py`: copy atlas files and rename.

3. Submit connectome generation scripts on Beluga
- `submit_connectome_CABNP.sh` & `submit_connectome_BA.sh`

4. Generate a .tsv connectome per participant from the .h5 file
- `h5_to_tsv_prisme.py`: uses [this repo](https://github.com/SIMEXP/rs-autoregression-prediction).

5. Copy data to Elm `/data/orban/data/prisme-connectomes`

6. Archive on Beluga nearline - TO DO

