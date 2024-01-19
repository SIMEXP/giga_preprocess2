#!/bin/bash

GIGA_CONNECTOME_VERSION=0.4.1
DATASET="adhd200"

FMRIPREP_PATH="${SCRATCH}/${DATASET}_fmriprep-20.2.7lts"
OUTPUT_CONNECTOME=${SCRATCH}/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}
NEARLINE_ROOT="/nearline/ctb-pbellec/giga_preprocessing_2"

cd $OUTPUT_CONNECTOME
tar -vczf ${NEARLINE_ROOT}/${DATASET}_fmriprep-20.2.7lts/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}.tar.gz .
