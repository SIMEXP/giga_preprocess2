#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --output=/lustre07/scratch/nclarke/logs/oasis_conn/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/oasis_conn/%x_%A.out
#SBATCH --cpus-per-task=1
#SBATCH --time=02:30:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G
#SBATCH --array=1-46

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME=/home/${USER}/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre07/scratch/${USER}/oasis3_fmriprep-20.2.7lts_1689714556/oasis3_bids/fmriprep-20.2.7lts
CONNECTOME_OUTPUT=/lustre07/scratch/nclarke/oasis3_connectomes-${GIGA_CONNECTOME_VERSION}
WORKINGDIR=${CONNECTOME_OUTPUT}/working_directory
participant_labels=/home/${USER}/participant_labels.txt # One subject number per line

module load apptainer

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})
PARTICIPANT_OUTPUT="${CONNECTOME_OUTPUT}/${PARTICIPANT_LABEL}"

mkdir -p $WORKINGDIR

# Create participant-specific directory
mkdir -p ${PARTICIPANT_OUTPUT}

# Define strategies and atlases
STRATEGIES=("acompcor50" "simple" "simple+gsr" "scrubbing.2" "scrubbing.2+gsr" "scrubbing.5" "scrubbing.5+gsr")
ATLASES=("Schaefer20187Networks" "MIST" "DiFuMo")

# Loop through each strategy and atlas
for STRATEGY in "${STRATEGIES[@]}"; do
    for ATLAS in "${ATLASES[@]}"; do
        # Set AFC flag based on atlas
        if [[ "$ATLAS" == "DiFuMo" ]]; then
            INTRANETWORK_FLAG=""
        else
            INTRANETWORK_FLAG="--calculate-intranetwork-average-correlation"
        fi
        echo "Running ${PARTICIPANT_LABEL} with ${ATLAS} ${STRATEGY}"
        	apptainer run \
            --bind ${FMRIPREP_DIR}:/data/input \
            --bind ${SLURM_TMPDIR}:/data/output \
            --bind ${WORKINGDIR}:/data/working \
            ${GIGA_CONNECTOME} \
            -w /data/working \
            --atlas ${ATLAS} \
            --denoise-strategy ${STRATEGY} \
            ${INTRANETWORK_FLAG} \
            /data/input \
            /data/output \
            participant \
            --participant_label ${PARTICIPANT_LABEL}
        exitcode=$?  # catch exit code
        if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${PARTICIPANT_OUTPUT} ; fi
    done
done
