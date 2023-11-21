# srpbs-fmriprep-slurm
Scripts for preprocessing the SRPBS Multidisorder MRI Dataset (unrestricted) with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded from [here](https://bicr-resource.atr.jp/srpbsopen/) after creating an account and completing the registration form.

## BIDS validation fixes
- `1_copy_participant_tsv.sh`. Since there are some extra files included in the data download, I copied participants.tsv to `/data` and used that as the root for fMRIPrep.
- BOLD volumes were in individual NIfTI files:
    - `2_merge_nii.sh`  adds `.nii` extension to each volume and merges into one `.nii` file, correctly named (thanks to Quentin for help with this step!)
    - `3_remove_nii.sh` deletes the indiviudal volumes (decided to do this later, hence separate script).
- `4_rename_srpbs.py`
    - creates a session level directory and moves scan directories into it
    - renames scan folders in-line with BIDS convension
    - renames T1 files in-line with BIDS convension.
- `5_remove_mprage.sh` deletes the original T1 (as I copied as opposed to renaming directly)
- JSON sidecars for func files are missing:
    - `6_export_func_protocols.py` extracts scanning protocol for 14 sites from provided MRI_protocols_rsMRI.tsv and makes a few corrections
    - `7_create_subject_json.py` loops over participants, checks which protocol they were scanned with and adds relevant JSON to func directory.
- `8_create_dataset_description.py`
    -  creates `dataset_description.json` at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (same as adni, see [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)).
- `9_create_task-rest_bold.py`
    - creates `task-rest_bold.json` at the root directory, detailing bold task
- `10_create_bids_ignore.sh`
    - creates `.bidsignore` at the root and adds `fmap/`

## Run fMRIPrep
- `11_generate_slurm_script.sh`
- `12_archive_fmriprep.sh`

## Run QC
- `13_submit_qc_participant.sh`
- `14_archive_qc.sh`

## Generate connectomes
- `15_setup_connectome.sh` creates the BIDS database/layout.
- `16_submit_connectome.sh` loops through each participant and generates connectomes for each atlas and strategy pair.
    - To stay under the 1000 job limit, do `ls -d sub-* | grep -v '\.html$' | sed 's/sub-//' | head -n 1000 > /home/nclarke/participant_labels.txt`, and make sure number of array jobs is `1-1000`.
    - Once complete, do `ls -d sub-* | grep -v '\.html$' | sed 's/sub-//' | tail -n 399 > /home/nclarke/participant_labels.txt`, and make sure number of array jobs is `1-399`.
- `17_check_participant_missing_h5.py` checks which subjects failed in the previous step.
- `18_connectome_slurm_array_missing.bash` and `18_submit_connectome_array_missing.sh` submit any failed atlas/strategy pairs one by one. Use the portal to check if jobs are timed out/ OOM and adjust accordingly, but if they failed after that will be due to no frames left after scrubbing.
- `19_archive_connectome.sh` since ran on Narval, then moved to Beluga nearline.

Note, QC and connectomes ran on Narval and moved to Beluga nearline.
