#!/bin/bash
#SBATCH --account=rrg-pbellec
GIGA_CONNECTOME_VERSION=0.4.1
DATASET="cobre"

FMRIPREP_PATH="/lustre04/scratch/${USER}/${DATASET}_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts"
CONNECTOME="/home/nclarke/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}"

STRATEGIES="simple simple+gsr scrubbing.5 scrubbing.5+gsr scrubbing.2 scrubbing.2+gsr acompcor50"
ATLASES="Schaefer20187Networks MIST DiFuMo"

for strategy in $STRATEGIES; do
    for atlas in $ATLASES; do
            mem=8G
            time="6:00:00"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="10:00:00"
                mem=32G
            fi

            if [ ! -f "${CONNECTOME}/atlas-${atlas}_desc-${strategy}.h5" ]; then
                echo "Submitting ${atlas} ${strategy}"
                sbatch \
                    --time=${time} --mem-per-cpu=${mem} \
                    --job-name=${DATASET}_${atlas}_${strategy} \
                    --export=DATASET="${DATASET}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                    ./connectome_slurm_nosite.bash
            else
                echo "Skipping ${atlas} ${strategy}"
            fi
    done
done
