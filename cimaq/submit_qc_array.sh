#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cimaq_qc
#SBATCH --output=/lustre07/scratch/nclarke/logs/%x_%A.%a.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/%x_%A.%a.out
#SBATCH --time=00:15:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --array=1-246

module load apptainer

FMRIPREP_DIR=/home/nclarke/scratch/cimaq_fmriprep-20.2.7lts_1687549726/CIMAQ/fmriprep-20.2.7lts/derivatives
GIGA_AUTO_QC_CONTAINER=/lustre05/home/nclarke/giga_auto_qc-0.3.3.simg
QC_OUTPUT="/lustre07/scratch/nclarke/cimaq_giga_auto_qc-0.3.3"
participant_labels="/home/nclarke/participant_labels.txt" # One subject number per line

mkdir -p $QC_OUTPUT

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})

# Create a directory for participant
PARTICIPANT_OUTPUT="${QC_OUTPUT}/${PARTICIPANT_LABEL}"
mkdir -p $PARTICIPANT_OUTPUT

echo "Running ${PARTICIPANT_LABEL} QC"

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${PARTICIPANT_OUTPUT}:/outputs ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs participant --participant_label ${PARTICIPANT_LABEL}


