#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc
#SBATCH --output=/lustre07/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/%x_%A.out
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G
#SBATCH --array=1-747

module load apptainer

FMRIPREP_DIR=/lustre07/scratch/${USER}/adni_bids_output_func/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/home/${USER}/giga_auto_qc-0.3.3.simg
QC_OUTPUT=/lustre07/scratch/${USER}/adni_giga_auto_qc-0.3.3_scrub.5
QC_PARAMS=/home/${USER}/qc_params_scrub5.json
participant_labels=/home/${USER}/participant_labels.txt # One subject number per line

mkdir -p $QC_OUTPUT

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})

# Create a directory for participant
PARTICIPANT_OUTPUT="${QC_OUTPUT}/${PARTICIPANT_LABEL}"
mkdir -p $PARTICIPANT_OUTPUT

echo "Running ${PARTICIPANT_LABEL} QC"

apptainer run --cleanenv -B ${QC_PARAMS} -B ${FMRIPREP_DIR}:/inputs -B ${PARTICIPANT_OUTPUT}:/outputs ${GIGA_AUTO_QC_CONTAINER} /inputs /outputs --quality_control_parameters ${QC_PARAMS} participant --participant_label ${PARTICIPANT_LABEL}
