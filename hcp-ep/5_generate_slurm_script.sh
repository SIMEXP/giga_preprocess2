#!/bin/bash
#SBATCH --mem-per-cpu=12288
#SBATCH --time=01:00:00
#SBATCH --account=rrg-pbellec

CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.7"
EMAIL=${SLACK_EMAIL_BOT}

module load singularity/3.8
echo "Create fmriprep-slurm scripts for HCP-EP"

DATASET_PATH="/lustre04/scratch/${USER}/imagingcollection01"
echo $DATASET_PATH
time=`date +%s`
OUTPUT_PATH="/lustre04/scratch/nclarke/hcp-ep_fmriprep-${VERSION}lts"

mkdir -p $OUTPUT_PATH

# run BIDS validator on the dataset
# you only need this done once
singularity exec -B ${DATASET_PATH}:/DATA \
    ${CONTAINER_PATH}/fmriprep-${VERSION}lts.sif bids-validator /DATA \
    > ${OUTPUT_PATH}/bids_validator.log

# running the script from the current directory, reference
# fmriprep_slurm_singularity_run.bash from one level up
bash ../scripts/fmriprep_slurm_singularity_run.bash \
    ${OUTPUT_PATH} \
    ${DATASET_PATH} \
    fmriprep-${VERSION}lts \
    --fmriprep-args=\"--ignore slicetiming fieldmaps\" \
    --email=${EMAIL} \
    --time=50:00:00 \
    --mem-per-cpu=12288 \
    --cpus=1 \
    --container fmriprep-${VERSION}lts