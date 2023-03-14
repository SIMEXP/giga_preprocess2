#!/bin/bash
CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.1"
EMAIL=${SLACK_EMAIL_BOT}

module load singularity/3.8
echo "Create fmriprep-slurm scripts for ds000030"

DATASET_PATH="/lustre04/scratch/${USER}/openneuro/ds000030"
time=`date +%s`
OUTPUT_PATH="/lustre04/scratch/hwang1/ds000030_fmriprep-${VERSION}lts"
SITES=`ls $DATASET_PATH`

mkdir -p $OUTPUT_PATH

# run BIDS validator on the dataset
# you only need this done once
singularity exec -B ${DATASET_PATH}:/DATA \
    ${CONTAINER_PATH}/fmriprep-20.2.1lts.sif bids-validator /DATA

# running the script from the curre directory, reference
# fmriprep_slurm_singularity_run.bash from one level up
bash ../scripts/fmriprep_slurm_singularity_run.bash \  
    ${OUTPUT_PATH} \
    ${DATASET_PATH} \
    fmriprep-${VERSION}lts \
    --fmriprep-args=\"--use-aroma\" \
    --email=${EMAIL} \
    --time=36:00:00 \
    --mem-per-cpu=12288 \
    --cpus=1 \
    --container fmriprep-${VERSION}lts