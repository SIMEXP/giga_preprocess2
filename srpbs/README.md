# srpbs-fmriprep-slurm
Scripts for preprocessing the SRPBS Multidisorder MRI Dataset (unrestricted) with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded from [here](https://bicr-resource.atr.jp/srpbsopen/) after creating an account and completing the registration form.

## BIDS validation fixes
1. `1_copy_participant_tsv.sh`. Since there are some extra files included in the data download, I copied participants.tsv to `/data` and used that as the root for fMRIPrep.
2. BOLD volumes were in individual NIfTI files:
    - `2_merge_nii.sh`  adds `.nii` extension to each volume and merges into one `.nii` file, correctly named (thanks to Quentin for help with this step!)
    - `3_remove_nii.sh` deletes the indiviudal volumes (decided to do this later, hence separate script).
3. `4_rename_srpbs.py`
    - creates a session level directory and moves scan directories into it
    - renames scan folders in-line with BIDS convension
    - renames T1 files in-line with BIDS convension.
4.  `5_remove_mprage.sh` deletes the original T1 (as I copied as opposed to renaming directly)
5. JSON sidecars for func files are missing:
    - `6_export_func_protocols.py` extracts scanning protocol for 14 sites from provided MRI_protocols_rsMRI.tsv and makes a few corrections
    - `7_create_subject_json.py` loops over participants, checks which protocol they were scanned with and adds relevant JSON to func directory.
6. `8_create_dataset_description.py`
    -  creates `dataset_description.json` at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (same as adni, see [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)).
7. `9_create_task-rest_bold.py`
    - creates `task-rest_bold.json` at the root directory, detailing bold task
8. `10_create_bids_ignore.sh`
    - creates `.bidsignore` at the root and adds `fmap/`


