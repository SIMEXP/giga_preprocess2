# cima-q-fmriprep-slurm
Scripts for preprocessing the Consortium for the Early Identification of Alzheimer’s Disease (CIMA-Q) with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
## Retrieving data
Data was downloaded from the LORIS platform after obtaining appropriate data access approval.

## Scripts to make data BIDS compliant
1. `1_create_participants_tsv.sh` copies the provided `demographie_et_diagnostic_initial.tsv` to `participants_tsv` and renames the PSCID column to participant_id
2. `2_create_bidsignore.sh` creates `.bidsignore` at the root and adds directories and files which are not needed
3. `3_create_dataset_description.py` creates `dataset_description.json` at the root directory with minimal information

## Notes on connectome generation
- Ran on narval and moved to Beluga nearline (same for QC).
- Most participants completed in less than one minute. If timed-out, re-ran with increased wall time.
- The following subjects are missing cosine regressors (realised after I had submitted the array): \
**memory only**: 4331322, 5788838, 7485585, 8069157, 5036272, 8060583, 7720517, 6417837, 5359706, 7853010 \
**rest only**: 6371164



