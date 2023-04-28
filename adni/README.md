# adni-fmriprep-slurm
Scripts for preprocessing ADNI data with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data not openly available. Used BIDS-ified dataset on Elm.
## BIDS errors
Ran the following scripts to fix errors:
1. `create_dataset_description.py`
    -  creates dataset_description.json at the root directory with minimal information
    -  BIDS version used is unknown, so specified latest version (see [discussion]( https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)).
    -  fixes BIDS validation error `code: 57 DATASET_DESCRIPTION_JSON_MISSING`

2. `create_task-rest_bold.py`
    - creates task-rest_bold.json at the root directory, detailing bold task
    - fixes BIDS validation error `code: 50 TASK_NAME_MUST_DEFINE`

3. `create_bidsignore.sh`
    - creates `.bidsignore` at the root and adds `*T1w_cropped.nii` to ignore these files, which are not needed
    - fixes BIDS validation error `code: 1 - NOT_INCLUDED`
    - TODO: check this also fixes error `code: 63 - SESSION_VALUE_CONTAINS_ILLEGAL_CHARACTER`, it should do

3. `correct_slice_timing.py`
    - halves the slice timing for sub-109S4594 (ses-20160502), which appears to be doubled (see [discussion](https://neurostars.org/t/help-with-bids-errors-66-and-75-in-legacy-dataset/25625))
    - fixes BIDS validation error `code: 66 SLICETIMING_VALUES_GREATOR_THAN_REPETITION_TIME`

n.b. error `code: 75 - NIFTI_PIXDIM4` affected two subjects. Suggested fix to edit nifti header fields (see [discussion](https://neurostars.org/t/help-with-bids-errors-66-and-75-in-legacy-dataset/25625/2)). One subject would fail anyway, since `Time` field is `0`, so in interests of saving time I have left this for now.

