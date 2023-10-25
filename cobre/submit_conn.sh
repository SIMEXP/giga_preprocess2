#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cobre_connectome
#SBATCH --output=/lustre04/scratch/nclarke/logs/cobre_conn.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cobre_conn.%a.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

module load apptainer/1.1.8

FMRIPREP_DIR=/lustre04/scratch/${USER}/cobre_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-0.4.1.simg
OUTPUT_DIR="/home/nclarke/cobre_connectomes-0.4.1"

mkdir -p ${OUTPUT_DIR}

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${OUTPUT_DIR}:/outputs ${GIGA_AUTO_QC_CONTAINER} --atlas MIST --denoise-strategy scrubbing.5+gsr --calculate-intranetwork-average-correlation /inputs /outputs group
