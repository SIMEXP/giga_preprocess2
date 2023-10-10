#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=srpbs_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/srpbs_qc.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/srpbs_qc.%a.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

source /lustre03/project/6003287/nclarke/.virtualenvs/giga_auto_qc/bin/activate

FMRIPREP_PATH=/home/nclarke/scratch/srpbs_fmriprep-20.2.7lts_1691842839/data/fmriprep-20.2.7lts
QC_OUTPUT=/lustre04/scratch/${USER}/srpbs_qc

# Loop through each subject's directory
for subject_dir in $FMRIPREP_PATH/derivatives/sub-*; do
    # Check if the directory contains .html files and skip it if it does
        if [[ -n $(find "$subject_dir" -maxdepth 1 -type f -name "*.html") ]]; then
        echo "Skipping subject directory with .html files: $subject_dir"
        continue
    fi

    subject_label=$(basename $subject_dir)
    subject_label=${subject_label#sub-}  # Remove "sub-"

    # Check if the subject number is greater than or equal to "0468"
    if [ "$subject_label" -ge "0468" ]; then
        echo "Processing subject: $subject_label"

        # Create a directory for the current subject
        subject_output_dir="$QC_OUTPUT/$subject_label"
        mkdir -p "$subject_output_dir"

        # Run for the current subject
        giga_auto_qc $FMRIPREP_PATH "$subject_output_dir" participant --participant_label $subject_label
    fi
done
