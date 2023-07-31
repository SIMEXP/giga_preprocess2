# oasis3-fmriprep-slurm
Scripts for preprocessing the OASIS3 dataset with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded following the 'Scripted Download Instructions' [here](https://www.oasis-brains.org/), after registering for an account at XNAT Central and PB signing the data agreement.

## Scripts to make data BIDS compliant
1. `1_create_task-rest_bold.py`
    - creates task-rest_bold.json at the root directory, detailing BOLD task

2. `2_copy_dataset_description.sh`
    - dataset contains dataset_description.json but in each individual subject folder. This script copies one to the root directory

3. `3_create_bidsignore.sh`
    - creates a .bidsignore file at the root directory and adds files and directories to ignore

4. `4_rename_oasis.py`
    - renames files in-line with BIDS convention

## Notes
- Some subjects had multi-band fMRI, however the slice timing was incorrect, and since more subjects had single band I just processed the single-band data
- Also ignored any scans called *testrest*

