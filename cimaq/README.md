# cima-q-fmriprep-slurm
Scripts for preprocessing the Consortium for the Early Identification of Alzheimer’s Disease (CIMA-Q) with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
## Retrieving data
Data was downloaded from the LORIS platform after obtaining appropriate data access approval.

## Scripts to make data BIDS compliant
- `1_create_participants_tsv.sh` copies the provided `demographie_et_diagnostic_initial.tsv` to `participants_tsv` and renames the PSCID column to participant_id
- `2_create_bidsignore.sh` creates `.bidsignore` at the root and adds directories and files which are not needed
- `3_create_dataset_description.py` creates `dataset_description.json` at the root directory with minimal information

## Run fMRIPrep
- `4_generate_slurm_script.sh`
- `5_archive_fmriprep.sh`

## Run QC
- `6_submit_qc_array.sh`
- `7_archive_qc.sh`

## Generate connectomes
- `8_connectome_slurm_array.bash` and `8_submit_connectome_array.sh`. Ran through once with MIST/simple only, group level analysis and `--reindex-bids` flag, then removed flag and ran participant level.
- Checked if any subjects were missing results and re-ran using same scripts as for srpbs, checking time-out/OOM using the portal.
- `9_archive_connectome.sh`
- The following subjects are missing cosine regressors and therefore connectomes: \
**memory only**: 4331322, 5788838, 7485585, 8069157, 5036272, 8060583, 7720517, 6417837, 5359706, 7853010 \
**rest only**: 6371164

Note, QC and connectomes ran on Narval and moved to Beluga nearline.



