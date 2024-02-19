#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=adni_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/adni_qc/%x_%A.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/adni_qc/%x_%A.%a.out
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --array=1-747

module load apptainer

FMRIPREP_DIR=/lustre04/scratch/nclarke/adni_fmriprep-20.2.7lts_1682352545/adni_bids_output_func/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/home/nclarke/projects/rrg-pbellec/nclarke/giga_preprocess2/giga_auto_qc-0.3.3.simg
QC_OUTPUT=/lustre04/scratch/nclarke/adni_giga_auto_qc-0.3.3_participant
participant_labels=/home/nclarke/projects/rrg-pbellec/nclarke/giga_preprocess2/adni/participant_labels.txt # One subject number per line

mkdir -p $QC_OUTPUT

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})

# Create a directory for participant
PARTICIPANT_OUTPUT="${QC_OUTPUT}/${PARTICIPANT_LABEL}"
mkdir -p $PARTICIPANT_OUTPUT

echo "Running ${PARTICIPANT_LABEL} QC"

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${PARTICIPANT_OUTPUT}:/outputs ${GIGA_AUTO_QC_CONTAINER} /inputs /outputs participant --participant_label ${PARTICIPANT_LABEL}
