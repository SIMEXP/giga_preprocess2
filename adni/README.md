1. create_dataset_description.py
    -  fixes BIDS validation error [code 57] DATASET_DESCRIPTION_JSON_MISSING.
    -  BIDS version used is unknown, so specified latest version (discussion here: https://neurostars.org/t/what-bids-version-to-use-for-legacy-dataset/25619)

2. create_task-rest_bold.py
    - fixes BIDS validation error [code 50] TASK_NAME_MUST_DEFINE

3. correct_slice_timing.py
    - fixes BIDS validation error [code 66] SLICETIMING_VALUES_GREATOR_THAN_REPETITION_TIME

