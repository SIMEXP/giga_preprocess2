# cobre-fmriprep-slurm
Scripts for preprocessing the COBRE dataset with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded from [here](http://fcon_1000.projects.nitrc.org/indi/retro/cobre.html) after registering for an account at NITRC and requesting access.

## Scripts to make data BIDS compliant
- `1_rename_cobre.py`
    - adds the suffix `sub-` to each subject folder
    - renames the session folder in-line with BIDS convension
    - renames scan folders in-line wtih BIDS convension
    - renames T1 and bold nifti files in-line with BIDS convension

- `2_scan_params_to_json.py`
    - creates a JSON file of scan parameters from the .csv provided with dataset
    - converts TR from miliseconds to seconds
        - double checked liklihood of this being correct by inspecting nifti headers with `n_header['pixdim'][4]` which returned `2`
    - saves JSON for each subject in func directory

- `3_create_dataset_description.py`
    -  creates dataset_description.json at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (same as adni [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)).

- `4_create_task-rest_bold.py`
    - creates task-rest_bold.json at the root directory, detailing bold task

## Run fMRIPrep
- `5_generate_slurm_script.sh`
- `6_archive_fmriprep.sh`

## Run QC
Using the following command:

```
module load apptainer

FMRIPREP_DIR=/lustre04/scratch/${USER}/cobre/COBRE/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/home/${USER}/projects/rrg-pbellec/${USER}/giga_preprocess2/giga_auto_qc-0.3.3.simg

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${SCRATCH}:/outputs ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs group
```

followed by:
- `7_archive_qc.sh`

## Generate connectomes
- `8_check_cosine.py` is a helper script to check that all subjects have cosine regressors available, otherwise the QC will get stuck.
- `9_connectome_slurm.bash` and `9_submit_connectome.sh`. Ran through once with MIST/simple only and `--reindex-bids` flag, then removed flag and ran the rest.
- `10_archive_connectome.sh`