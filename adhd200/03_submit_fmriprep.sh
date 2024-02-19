#!/bin/bash

DATASET=adhd200
VERSION=20.2.7
DATASET_PATH="/lustre04/scratch/hwang1/${DATASET}/"
OUTPUT_PATH="/lustre04/scratch/hwang1/${DATASET}_fmriprep-${VERSION}lts"
SITES=`ls $DATASET_PATH`

for site in ${SITES}; do
    find "${OUTPUT_PATH}/${site}"/.slurm/smriprep_sub-*.sh -type f | while read file; do sbatch "$file"; done
done
