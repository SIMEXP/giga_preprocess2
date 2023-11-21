#!/bin/bash
#SBATCH --account=def-pbellec

DATASET="cimaq"
CONNECTOME_OUTPUT=/home/nclarke/scratch/cimaq_connectomes-0.4.1

STRATEGIES="simple" #"simple+gsr" "scrubbing.2" "scrubbing.2+gsr" "scrubbing.5" "scrubbing.5+gsr" "acompcor50"
ATLASES=("Schaefer20187Networks" "MIST" "DiFuMo")

for strategy in "$STRATEGIES"; do
    for atlas in "${ATLASES[@]}"; do
            mem=8G
            time="00:05:00"
            INTRANETWORK_FLAG="--calculate-intranetwork-average-correlation"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="00:12:00"
                mem=12G
                INTRANETWORK_FLAG=""
            fi

            echo "Submitting ${atlas} ${strategy}"
            sbatch \
                --time=${time} --mem-per-cpu=${mem} \
                --job-name=${DATASET}_${atlas}_${strategy} \
                --export=DATASET="${DATASET}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                ./connectome_slurm_array.bash
    done
done
