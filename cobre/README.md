# cobre-fmriprep-slurm
Scripts for preprocessing the Center for Biomedical Research Excellence (COBRE) dataset with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded from [here](http://fcon_1000.projects.nitrc.org/indi/retro/cobre.html) after registering for an account at NITRC and requesting access.

## Pre-BIDS validation fixes
1. `rename_cobre.py`
    - adds the suffix `sub-` to each subject folder
    - renames the session folder in-line with BIDS convension
    - renames scan folders in-line wtih BIDS convension
    - renames T1 and bold nifti files in-line with BIDS convension

2. `scan_params_to_json.py`
    - creates a JSON file of scan parameters from the .csv provided with dataset
    - converts TR from miliseconds to seconds
        - double checked liklihood of this being correct by inspecting nifti headers with `n_header['pixdim'][4]` which returned `2`
    - saves JSON for each subject in func directory

## BIDS errors
Ran the following scripts to fix errors:
1. `create_dataset_description.py`
    -  creates dataset_description.json at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (same as adni [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)).
    -  fixes BIDS validation error `code: 57 DATASET_DESCRIPTION_JSON_MISSING`

2. `create_task-rest_bold.py`
    - creates task-rest_bold.json at the root directory, detailing bold task
    - fixes BIDS validation error `code: 50 TASK_NAME_MUST_DEFINE`

