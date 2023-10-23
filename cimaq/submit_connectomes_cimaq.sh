#!/bin/bash
#SBATCH --account=rrg-pbellec
GIGA_CONNECTOME_VERSION=0.4.1
DATASET="cimaq"

FMRIPREP_PATH="/lustre04/scratch/${USER}/${DATASET}_fmriprep-20.2.7lts_1687549726/CIMAQ/fmriprep-20.2.7lts/derivatives"
CIMAQ_CONNECTOME="/home/nclarke/cimaq_connectomes-0.4.1"

site=cimaq_test
STRATEGIES="simple simple+gsr scrubbing.5 scrubbing.5+gsr scrubbing.2 scrubbing.2+gsr acompcor50"
ATLASES="Schaefer20187Networks MIST DiFuMo"

echo $FMRIPREP_PATH

for strategy in $STRATEGIES; do
    for atlas in $ATLASES; do
            mem=8G
            time="6:00:00"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="10:00:00"
                mem=32G
            fi

            if [ ! -f "${CIMAQ_CONNECTOME}/${site}/atlas-${atlas}_desc-${strategy}.h5" ]; then
                echo "Submitting ${site} ${atlas} ${strategy}"
                sbatch \
                    --time=${time} --mem-per-cpu=${mem} \
                    --job-name=${DATASET}_${site}_${atlas}_${strategy} \
                    --export=DATASET="${DATASET}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                    ./connectome_slurm_cimaq.bash
            else
                echo "Skipping ${site} ${atlas} ${strategy}"
            fi
    done
done
