#!/bin/bash

GIGA_CONNECTOME_VERSION=0.4.1
DATASET="abide2"

FMRIPREP_PATH="/lustre04/scratch/hwang1/${DATASET}_fmriprep-20.2.7lts"
ABIDE_CONNECTOME=/lustre04/scratch/${USER}/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}

SITES=`ls $FMRIPREP_PATH`
STRATEGIES="simple simple+gsr scrubbing.5 scrubbing.5+gsr scrubbing.2 scrubbing.2+gsr acompcor50"
ATLASES="Schaefer20187Networks MIST DiFuMo"
SITES="IU_1 KUL_3 OHSU_1 ONRC_2"
for strategy in $STRATEGIES; do
    for atlas in $ATLASES; do
        for site in $SITES; do
            mem=8G
            time="4:00:00"

            if [ "${site}" == "ONRC_2" ]; then
                time="12:00:00"
                mem=16G
            fi

            if [ "${atlas}" == "DiFuMo" ]; then
                time="12:00:00"
                mem=64G
                if [ "${site}" == "ONRC_2" ]; then
                    time="24:00:00"
                    mem=64G
                fi
            fi

            if [ ! -f "${ABIDE_CONNECTOME}/${site}/atlas-${atlas}_desc-${strategy}.h5" ]; then
                echo "Submitting ${site} ${atlas} ${strategy}"
                sbatch \
                    --time=${time} --mem-per-cpu=${mem} \
                    --job-name=${DATASET}_${site}_${atlas}_${strategy} \
                    --export=DATASET="${DATASET}",SITE="${site}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                    ./connectome_slurm_abide.bash
            else
                echo "Skipping ${site} ${atlas} ${strategy}"
            fi

        done
    done
done

