#!/bin/bash
#SBATCH --account=rrg-pbellec

DATASET="cobre"

GIGA_CONNECTOME_VERSION=0.4.1
COBRE_CONNECTOME=/lustre04/scratch/${USER}/${DATASET}_connectome-${GIGA_CONNECTOME_VERSION}

STRATEGIES=("simple simple+gsr scrubbing.5 scrubbing.5+gsr scrubbing.2 scrubbing.2+gsr acompcor50")
ATLASES=("Schaefer20187Networks MIST DiFuMo")

for strategy in ${STRATEGIES[@]}; do
    for atlas in ${ATLASES[@]}; do
            mem=4G
            time="02:00:00"
            INTRANETWORK_FLAG="--calculate-intranetwork-average-correlation"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="04:00:00"
                mem=12G
                INTRANETWORK_FLAG=""
            fi

            if [ ! -f "${COBRE_CONNECTOME}/atlas-${atlas}_desc-${strategy}.h5" ]; then
                echo "Submitting ${atlas} ${strategy}"
                sbatch \
                    --time=${time} --mem-per-cpu=${mem} \
                    --job-name=${DATASET}_${atlas}_${strategy} \
                    --export=DATASET="${DATASET}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                    ./connectome_slurm.bash
            else
                echo "Skipping ${atlas} ${strategy}"
            fi
    done
done
