#!/bin/bash
#SBATCH --account=rrg-pbellec

DATASET="adni"

STRATEGIES=("acompcor50" "simple" "simple+gsr" "scrubbing.2" "scrubbing.2+gsr" "scrubbing.5" "scrubbing.5+gsr")
ATLASES=("Schaefer20187Networks" "MIST" "DiFuMo")  

for strategy in "$STRATEGIES"; do
    for atlas in "${ATLASES[@]}"; do
            mem=12G
            time="00:10:00"
            INTRANETWORK_FLAG="--calculate-intranetwork-average-correlation"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="00:12:00"
                mem=14G
                INTRANETWORK_FLAG=""
            fi

            echo "Submitting ${atlas} ${strategy}"
            sbatch \
                --time=${time} --mem-per-cpu=${mem} \
                --job-name=${DATASET}_${atlas}_${strategy} \
                --export=DATASET="${DATASET}",ATLAS="${atlas}",STRATEGY="${strategy}" \
                ./7_connectome_slurm_array.bash
    done
done
