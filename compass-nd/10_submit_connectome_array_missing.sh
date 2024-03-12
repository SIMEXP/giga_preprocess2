#!/bin/bash
#SBATCH --account=def-pbellec

DATASET="compass-nd"
CONNECTOME_OUTPUT=/lustre04/scratch/${USER}/compass-nd_connectome-0.4.1

STRATEGIES=("simple" "simple+gsr" "scrubbing.2" "scrubbing.2+gsr" "scrubbing.5" "scrubbing.5+gsr" "acompcor50")
ATLASES=("DiFuMo" "Schaefer20187Networks" "MIST")

for strategy in "${STRATEGIES[@]}"; do
    for atlas in "${ATLASES[@]}"; do
            mem=8G
            time="00:15:00"
            INTRANETWORK_FLAG="--calculate-intranetwork-average-correlation"

            if [ "${atlas}" == "DiFuMo" ]; then
                time="00:25:00"
                mem=12G
                INTRANETWORK_FLAG=""
            fi

            # Generate the participant_labels file based on the missing file information
            missing_file="missing_atlas-${atlas}_desc-${strategy}.h5.txt"
            participant_labels="/lustre03/project/rrg-pbellec/nclarke/giga_preprocess2/compass-nd/${missing_file}"
            echo "participant_labels: ${participant_labels}"

            # Determine the array size based on the number of directories missing
            array_size=$(wc -l < "$participant_labels")
            echo "ARRAY_SIZE: ${array_size}"

            echo "Submitting ${atlas} ${strategy}"
            sbatch \
                --time=${time} --mem-per-cpu=${mem} --array=1-${array_size}\
                --job-name=${DATASET}_${atlas}_${strategy} \
                --export=DATASET=${DATASET},ATLAS=${atlas},STRATEGY=${strategy},participant_labels=${participant_labels}\
                ./connectome_slurm_array_missing.bash
    done
done
