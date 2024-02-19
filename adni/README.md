# adni-fmriprep-slurm
Scripts for preprocessing ADNI data with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data not openly available. Used BIDS-ified dataset on Elm.
## BIDS validation fixes
Ran the following scripts to fix errors:
- `1_create_dataset_description.py`
    -  creates `dataset_description.json` at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (see [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619))
    -  fixes BIDS validation error `code: 57 DATASET_DESCRIPTION_JSON_MISSING`

- `2_create_task-rest_bold.py`
    - creates `task-rest_bold.json` at the root directory, detailing bold task
    - fixes BIDS validation error `code: 50 TASK_NAME_MUST_DEFINE`

- `3_create_bidsignore.sh`
    - creates `.bidsignore` at the root and adds `*T1w_cropped.nii` to ignore these files, which are not needed
    - fixes BIDS validation error `code: 1 - NOT_INCLUDED`
    - TODO: check this also fixes error `code: 63 - SESSION_VALUE_CONTAINS_ILLEGAL_CHARACTER`, it should do

- `4_correct_slice_timing.py`
    - halves the slice timing for sub-109S4594 (ses-20160502), which appears to be doubled (see [discussion](https://neurostars.org/t/help-with-bids-errors-66-and-75-in-legacy-dataset/25625))
    - fixes BIDS validation error `code: 66 SLICETIMING_VALUES_GREATOR_THAN_REPETITION_TIME`

## Run fMRIPrep
- `5_generate_slurm_script.sh`
- `6_archive_fmriprep.sh`

## Run QC
- `7_submit_qc_array.sh`
    - run once with `--reindex-bids` flag on one participant to build the database layout (increase wall time)
    - remove flag and run again with all participants.
- `8_archive_qc.sh`

## Generate connectomes
- `9_connectome_slurm_array.bash` and `9_submit_connectome_array.sh`. As above run once with `--reindex-bids` flag and one atlas/strategy. I submitted each atlas/strategy pair individually because I hadn't yet figured out the optimal way to submit them (see e.g. HCP-EP)
- `10_archive_connectome.sh`

n.b. error `code: 75 - NIFTI_PIXDIM4` affected two subjects. Suggested fix to edit nifti header fields (see [discussion](https://neurostars.org/t/help-with-bids-errors-66-and-75-in-legacy-dataset/25625/2)). One subject would fail anyway, since `Time` field is `0`, so in interests of saving time I have left this for now.

n.b.(b?) around 100 subjects processed without --use-aroma flag. Used detect_timeout.py script to remove.
