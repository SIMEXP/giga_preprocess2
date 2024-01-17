#!/bin/bash

GIGA_CONNECTOME_VERSION=0.4.1
DATASET="adhd200"

FMRIPREP_PATH="/lustre04/scratch/hwang1/${DATASET}_fmriprep-20.2.7lts"
OUTPUT_CONNECTOME=/lustre04/scratch/${USER}/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}

SITES=`ls $FMRIPREP_PATH`
STRATEGIES="simple simple+gsr scrubbing.5 scrubbing.5+gsr scrubbing.2 scrubbing.2+gsr acompcor50"
ATLASES="Schaefer20187Networks MIST DiFuMo"
for site in $SITES; do
    for atlas in $ATLASES; do
        for strategy in $STRATEGIES; do
            mem=8G
            if [ "${site}" == "NYU" ]; then
                time="8:00:00"
            else
                time="4:00:00"
            fi

            if [ "${atlas}" == "DiFuMo" ]; then
                if [ "${site}" == "NYU" ]; then
                    time="12:00:00"
                else
                    time="8:00:00"
                fi
                mem=32G
            fi

            if [ ! -f "${OUTPUT_CONNECTOME}/${site}/atlas-${atlas}_desc-${strategy}.h5" ]; then
                echo "Submitting ${site} ${atlas} ${strategy}"
                # sbatch \
                #     --time=${time} --mem-per-cpu=${mem} \
                #     --job-name=${DATASET}_${site}_${atlas}_${strategy} \
                #     --export=DATASET="${DATASET}",SITE="${site}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                #     ./connectome_slurm.bash
            else
                echo "Skipping ${site} ${atlas} ${strategy}"
            fi

        done
    done
done
