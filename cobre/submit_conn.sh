#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cobre_connectome
#SBATCH --output=/lustre04/scratch/nclarke/logs/cobre_conn.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cobre_conn.%a.err
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

module load apptainer

FMRIPREP_DIR=/lustre04/scratch/${USER}/cobre_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-0.4.1.simg

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${SCRATCH}:/outputs ${GIGA_AUTO_QC_CONTAINER} --atlas MIST --denoise-strategy simple+gsr --reindex-bids --calculate-intranetwork-average-correlation /inputs /outputs group
