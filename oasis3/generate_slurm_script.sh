#!/bin/bash
#SBATCH --mem-per-cpu=12288
#SBATCH --time=02:00:00

CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.7"
EMAIL=${SLACK_EMAIL_BOT}

module load singularity/3.8
echo "Create fmriprep-slurm scripts for OASIS3"

DATASET_PATH="/lustre04/scratch/${USER}/oasis3_bids"
echo $DATASET_PATH
time=`date +%s`
OUTPUT_PATH="/lustre04/scratch/nclarke/oasis3_fmriprep-${VERSION}lts_${time}"

mkdir -p $OUTPUT_PATH

# run BIDS validator on the dataset
# you only need this done once
singularity exec -B ${DATASET_PATH}:/DATA \
    ${CONTAINER_PATH}/fmriprep-${VERSION}lts.sif bids-validator /DATA \
    --verbose \
    > ${OUTPUT_PATH}/bids_validator.log

# running the script from the current directory, reference
# fmriprep_slurm_singularity_run.bash from one level up
bash ../scripts/fmriprep_slurm_singularity_run.bash \
    ${OUTPUT_PATH} \
    ${DATASET_PATH} \
    fmriprep-${VERSION}lts \
    --fmriprep-args=\"--ignore slicetiming\" \
    --email=${EMAIL} \
    --time=36:00:00 \
    --mem-per-cpu=12288 \
    --cpus=1 \
    --container fmriprep-${VERSION}lts
