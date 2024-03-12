#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=oasis_qc
#SBATCH --output=/lustre07/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/%x_%A.out
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G
#SBATCH --array=1-46

module load apptainer

GIGA_QC_VERSION=0.3.3
FMRIPREP_DIR=/lustre07/scratch/${USER}/oasis3_fmriprep-20.2.7lts_1689714556/oasis3_bids/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/lustre05/home/${USER}/giga_auto_qc-${GIGA_QC_VERSION}.simg
QC_OUTPUT=/lustre07/scratch/${USER}/oasis3_giga_auto_qc_participant-${GIGA_QC_VERSION}
participant_labels=/home/${USER}/participant_labels.txt # One subject number per line

mkdir -p $QC_OUTPUT

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})

# Create a directory for participant
PARTICIPANT_OUTPUT="${QC_OUTPUT}/${PARTICIPANT_LABEL}"
mkdir -p $PARTICIPANT_OUTPUT

echo "Running ${PARTICIPANT_LABEL} QC"

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${PARTICIPANT_OUTPUT}:/outputs ${GIGA_AUTO_QC_CONTAINER} /inputs /outputs participant --participant_label ${PARTICIPANT_LABEL}
