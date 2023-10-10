#!/bin/bash
# unarchive abide data from nearline to scratch and each site is a fmriprep output
# Usage: ./unarchive_data.sh <dataset>

DATASET=$1

NEARLINE=~/nearline/ctb-pbellec/giga_preprocessing_2/${DATASET}_fmriprep-20.2.7lts/${DATASET}_fmriprep-20.2.7lts/
mkdir ~/scratch/${DATASET}_fmriprep-20.2.7lts

SITES=`ls $NEARLINE`

for site in ${SITES}; do
    site_name="${site%.*}"
    echo $site_name
    mkdir -p ~/scratch/${DATASET}_fmriprep-20.2.7lts/$site_name
    
    tar -xf ${NEARLINE}/$site_name.tar \
        -C ~/scratch/${DATASET}_fmriprep-20.2.7lts/$site_name \
        --wildcards "./fmriprep-20.2.7lts/sub-*/*/" \
        --strip-components=2 \
        --skip-old-files &
        
    tar -xf ${NEARLINE}/$site_name.tar \
        -C ~/scratch/${DATASET}_fmriprep-20.2.7lts/$site_name \
        --wildcards "./fmriprep-20.2.7lts/dataset_description.json" \
        --strip-components=2 \
        --skip-old-files &
done
