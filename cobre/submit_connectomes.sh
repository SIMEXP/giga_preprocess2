#!/bin/bash
#SBATCH --account=rrg-pbellec
GIGA_CONNECTOME_VERSION=0.4.1
DATASET="cobre"

FMRIPREP_PATH="/lustre04/scratch/nclarke/cobre_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts/"
COBRE_CONNECTOME=/home/nclarke/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}/

site=cobre_test
STRATEGIES="simple"
ATLASES="Schaefer20187Networks MIST DiFuMo"

for strategy in $STRATEGIES; do
    for atlas in $ATLASES; do
            mem=8G
            time="6:00:00"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="10:00:00"
                mem=32G
            fi

            if [ ! -f "${COBRE_CONNECTOME}/${site}/atlas-${atlas}_desc-${strategy}.h5" ]; then
                echo "Submitting ${site} ${atlas} ${strategy}"
                sbatch \
                    --time=${time} --mem-per-cpu=${mem} \
                    --job-name=${DATASET}_${site}_${atlas}_${strategy} \
                    --export=DATASET="${DATASET}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                    ./connectome_slurm.bash
            else
                echo "Skipping ${site} ${atlas} ${strategy}"
            fi
    done
done
