#!/bin/bash
# generate fmriprep slurm scripts for ABIDE dataset
# usage: bash generate_fmriprep_slurm_script_abide2.sh <dataset>

DATASET=$1

CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.7"
EMAIL=${SLACK_EMAIL_BOT}

module load singularity/3.8
echo "Create fmriprep-slurm scripts for ${DATASET}"

DATASET_PATH="/lustre04/scratch/hwang1/${DATASET}/"
OUTPUT_PATH="/lustre04/scratch/hwang1/${DATASET}_fmriprep-${VERSION}lts"
SITES=`ls $DATASET_PATH`

mkdir -p $OUTPUT_PATH

for site in ${SITES}; do
    mkdir -p ${OUTPUT_PATH}/${site}
    singularity exec -B ${DATASET_PATH}/${site}:/DATA \
        ${CONTAINER_PATH}/fmriprep-${VERSION}lts.sif bids-validator --verbose /DATA \
        > ${OUTPUT_PATH}/${site}/bids_validator.log

    bash ../scripts/fmriprep_slurm_singularity_run.bash \
        ${OUTPUT_PATH} \
        ${DATASET_PATH}/${site} \
        fmriprep-${VERSION}lts \
        --email=${EMAIL} \
        --time=26:00:00 \
        --mem-per-cpu=6144 \
        --cpus=1 \
        --container fmriprep-${VERSION}lts
done
