# OASIS3-fmriprep-slurm
Scripts for preprocessing the OASIS3 dataset with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data was downloaded following the 'Scripted Download Instructions' [here](https://www.oasis-brains.org/), after registering for an account at XNAT Central and PB signing the data agreement.

## BIDS validation fixes
1. `1_create_task-rest_bold.py`
    - creates task-rest_bold.json at the root directory, detailing BOLD task

2. `2_copy_dataset_description.sh`
    - dataset contains dataset_description.json but in each individual subject folder. This script copies one to the root directory

3. `3_create_bidsignore.sh`
    - creates a .bidsignore file at the root directory and adds files and directories to ignore

4. `4_rename_oasis.py`
    - renames files in-line with BIDS convention

## Run fMRIPrep
- `5_generate_slurm_script.sh`
- `6_archive_fmriprep.sh`

## Run QC
- `7_submit_qc_participant.sh`
- `8_archive_qc.sh`

## Generate connectomes
- `9_submit_connectome.sh` loops through each participant and generates connectomes for each atlas and strategy pair.
    - To stay under the 1000 job limit, do `ls -d sub-* | grep -v '\.html$' | sed 's/sub-//' | head -n 1000 > /home/nclarke/participant_labels.txt`, and make sure number of array jobs is `1-1000`.
    - Once complete, do `ls -d sub-* | grep -v '\.html$' | sed 's/sub-//' | tail -n 46 > /home/nclarke/participant_labels.txt`, and make sure number of array jobs is `1-46`.
- `10_check_participant_missing_h5.py` checks which subjects failed in the previous step.
- `11_connectome_slurm_array_missing.bash` and `11_submit_connectome_array_missing.sh` submit any failed atlas/strategy pairs one by one. Use the portal to check if jobs are timed out/ OOM and adjust accordingly, but if they failed after that will be due to no frames left after scrubbing.
- `12_archive_connectome.sh`

## Notes
- Some subjects had multi-band fMRI, however the slice timing was incorrect, and since more subjects had single band I just processed the single-band data
- Also ignored any scans called *testrest*
- Although OASIS participants were recruited from a single site, I had some issues with the group QC/ connectome generation, so I ran at the participant level instead.
- Some steps run on Narval and outputs moved to Beluga.