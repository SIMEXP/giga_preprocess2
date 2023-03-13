#!/bin/bash
CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.1"
EMAIL=${SLACK_EMAIL_BOT}

module load singularity/3.8
echo "Create fmriprep-slurm scripts for abide 1"


DATASET_PATH="/lustre04/scratch/hwang1/abide/RawDataBIDS"
time=`date +%s`
OUTPUT_PATH="/lustre04/scratch/hwang1/abide1_fmriprep-${VERSION}lts_${time}"
SITES=`ls $DATASET_PATH`

mkdir -p $OUTPUT_PATH

for site in ${SITES}; do
    # run BIDS validator on the dataset
    # you only need this done once
    mkdir -p ${OUTPUT_PATH}/${site}

    singularity exec -B ${DATASET_PATH}/${site}:/DATA \
        ${CONTAINER_PATH}/fmriprep-20.2.1lts.sif bids-validator --verbose /DATA \
        > ${OUTPUT_PATH}/${site}/bids_validator.log

    bash ./fmriprep_slurm_singularity_run.bash \
        ${OUTPUT_PATH} \
        ${DATASET_PATH}/${site} \
        fmriprep-${VERSION}lts \
        --fmriprep-args=\"--use-aroma\" \
        --email=${EMAIL} \
        --time=36:00:00 \
        --mem-per-cpu=12288 \
        --cpus=1 \
        --container fmriprep-${VERSION}lts
done


DATASET_PATH="/lustre04/scratch/hwang1/abide2/RawData"
OUTPUT_PATH="/lustre04/scratch/hwang1/abide2_fmriprep-${VERSION}lts_${time}"
SITES=`ls $DATASET_PATH`

mkdir -p $OUTPUT_PATH

for site in ${SITES}; do
    mkdir -p ${OUTPUT_PATH}/${site}
    # run BIDS validator on the dataset
    # you only need this done once
    singularity exec -B ${DATASET_PATH}/${site}:/DATA \
        ${CONTAINER_PATH}/fmriprep-20.2.1lts.sif bids-validator --verbose /DATA \
        > ${OUTPUT_PATH}/${site}/bids_validator.log

    bash ./fmriprep_slurm_singularity_run.bash \
        ${OUTPUT_PATH} \
        ${DATASET_PATH}/${site} \
        fmriprep-${VERSION}lts \
        --fmriprep-args=\"--use-aroma\" \
        --email=${EMAIL} \
        --time=36:00:00 \
        --mem-per-cpu=12288 \
        --cpus=1 \
        --container fmriprep-${VERSION}lts
done
