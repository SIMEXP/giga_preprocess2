#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --output=/lustre07/scratch/nclarke/logs/srpbs_conn/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/srpbs_conn/%x_%A.out
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --array=1-399

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME="/home/nclarke/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg"
FMRIPREP_DIR="/home/nclarke/scratch/srpbs_fmriprep-20.2.7lts_1691842839/data/fmriprep-20.2.7lts/derivatives"
CONNECTOME_OUTPUT="/lustre07/scratch/nclarke/srpbs_connectomes-${GIGA_CONNECTOME_VERSION}"
WORKINGDIR="${CONNECTOME_OUTPUT}/working_directory"
participant_labels="/home/nclarke/participant_labels.txt" # One subject number per line

module load apptainer

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})
PARTICIPANT_OUTPUT="${CONNECTOME_OUTPUT}/${PARTICIPANT_LABEL}"

# Create participant-specific directory
mkdir -p ${PARTICIPANT_OUTPUT}
mkdir -p $WORKINGDIR

# Define strategies and atlases
STRATEGIES=("acompcor50" "simple" "simple+gsr" "scrubbing.2" "scrubbing.2+gsr" "scrubbing.5" "scrubbing.5+gsr")
ATLASES=("Schaefer20187Networks" "MIST" "DiFuMo")

# Loop through each strategy and atlas
for STRATEGY in "${STRATEGIES[@]}"; do
    for ATLAS in "${ATLASES[@]}"; do
        echo "Running ${PARTICIPANT_LABEL} with ${ATLAS} ${STRATEGY}"
        	apptainer run \
            --bind ${FMRIPREP_DIR}:/data/input \
            --bind ${SLURM_TMPDIR}:/data/output \
            ${GIGA_CONNECTOME} \
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
