# HCP-EP-fmriprep-slurm
Scripts for preprocessing Human Connectome Project - Early Psychosis (HCP-EP) with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
## Retrieving data
Data was downloaded from https://nda.nih.gov/ after obtaining appropriate data access approval.

## BIDS validation fixes
- `1_reorganise.py` and `1_submit_reorganise.sh` reorganise the MRI data and rename it in-line with BIDS convensions.
    - Since the downloaded MRI data is in the folder `imagingcollection01`, this serves as the root directory.
    - MRI data is organised into three session directories, following the HCP-EP imaging scanning protocol detailed [here](https://www.humanconnectome.org/hcp-protocols-ya-3t-imaging). Session 1 was for sructual acquisition, and then two sessions for rs-fMRI acquisition. Originally called REST1 and REST2, these are renames ses1 and ses2.
    - Within each rs-fMRI session there were two runs, with alternating phase-encoding direction. Originally named AP and PA, these are renamed to run1 and run2.
- `2_create_dataset_description.py` creates `dataset_description.json` at the root directory with minimal information
- `3_create_task-rest_bold.py`creates `task-rest_bold.json` at the root directory, detailing bold task
- `4_create_bidsignore.sh` creates `.bidsignore` at the root and adds a directory not needed

## Run fMRIPrep
- `5_generate_slurm_script.sh`
- `6_archive_fmriprep.sh`

## Run QC
- `7_submit_qc_scrub5.sh` runs the QC with updated parameters (scrubbing 0.5)
    - run once with `--reindex-bids` flag on one participant to build the database layout
    - remove flag and run again with all participants.
- `8_archive_qc.sh`

## Generate connectomes
- `9_submit_connectome.sh`. As above, run once with `--reindex-bids` and one atlas/strategy. n.b. all connectomes were generated, any missing are due to no frames left after scrubbing.
- `10_archive_connectome.sh`