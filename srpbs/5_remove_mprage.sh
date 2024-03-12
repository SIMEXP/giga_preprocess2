#!/bin/bash

data_dir="/lustre04/scratch/nclarke/SRPBS_OPEN_bids/data"

# Loop through each subject directory
for subj_dir in "$data_dir"/sub-*; do
    anat_dir="${subj_dir}/ses-mri/anat"
    # Check if anat directory exists
    if [ -d "$anat_dir" ]; then
        # Delete files starting with vol
        find "$anat_dir" -name "defaced*" -type f -delete
    fi
done
