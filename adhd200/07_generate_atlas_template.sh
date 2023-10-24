#!/bin/bash

GIGA_CONNECTOME_VERSION=0.4.1
DATASET="adhd200"

FMRIPREP_PATH="/lustre04/scratch/hwang1/${DATASET}_fmriprep-20.2.7lts"
OUTPUT_CONNECTOME=/lustre04/scratch/${USER}/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}

SITES=`ls $FMRIPREP_PATH`
STRATEGY="simple+gsr"
ATLASES="Schaefer20187Networks MIST DiFuMo"

for atlas in $ATLASES; do
    for site in $SITES; do

        mem=8G
        time="3:00:00"

        if [ "${atlas}" == "DiFuMo" ]; then
            time="6:00:00"
            mem=32G
        fi

        if [ ! -f "${OUTPUT_CONNECTOME}/${site}/atlas-${atlas}_desc-${STRATEGY}.h5" ]; then
            echo "Submitting ${site} ${atlas} ${STRATEGY}"
            sbatch \
                --time=${time} --mem-per-cpu=${mem} \
                --job-name=${DATASET}_${site}_${atlas}_${strategy} \
                --export=DATASET="${DATASET}",SITE="${site}",ATLAS="${atlas}",STRATEGY="${STRATEGY}" \
                ./connectome_slurm.bash
        else
            echo "Skipping ${site} ${atlas} ${STRATEGY}"
        fi
    done
done
