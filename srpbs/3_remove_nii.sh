#!/bin/bash

data_dir="/lustre04/scratch/nclarke/SRPBS_OPEN_bids/data"

# Loop through each subject directory
for subj_dir in "$data_dir"/sub-*; do
    func_dir="${subj_dir}/ses-mri/func"
    # Check if func directory exists
    if [ -d "$func_dir" ]; then
        # Delete files starting with vol
        find "$func_dir" -name "vol*" -type f -delete
    fi
done
