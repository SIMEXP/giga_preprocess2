# COMPASS-ND-fmriprep-slurm
Scripts for preprocessing the Comprehensive Assessment of Neurodegeneration and Dementia (COMPASS-ND) Study with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded from [here](https://ccna.loris.ca/) after submitting a data access request and receiving approval.

## BIDS validation fixes
- `1_create_dataset_description.py`
    -  creates `dataset_description.json` at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (same as adni, see [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)).
- `2_create_task-rest_bold.py`
    - creates `task-rest_bold.json` at the root directory, detailing bold task
- `3_create_bids_ignore.sh`
    - creates `.bidsignore` at the root and adds relevant lines

## Run fMRIPrep
- `4_generate_slurm_script.sh`
- `5_archive_fmriprep.sh`

## Run QC
- `6_submit_qc_participant.sh`
    - Run once first with one participant only and `--reindex-bids` flag.
- `7_archive_qc.sh`

## Generate connectomes
- `8_submit_connectome.sh` loops through each participant and generates connectomes for each atlas and strategy pair.
    - Run once first with one participant only and `--reindex-bids` flag.
    - Do `ls -d sub-* | grep -v '\.html$' | sed 's/sub-//' > /home/${USER}/participant_labels.txt`.
- `9_check_participant_missing_h5.py` checks which subjects failed in the previous step.
- `10_connectome_slurm_array_missing.bash` and `10_submit_connectome_array_missing.sh` submit any failed atlas/strategy pairs one by one. Use the portal to check if jobs are timed out/ OOM and adjust accordingly, but if they failed after that will be due to no frames left after scrubbing.
- `11_archive_connectome.sh`