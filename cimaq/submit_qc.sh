#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cimaq_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/cimaq_qc.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cimaq_qc.%a.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

module load apptainer

FMRIPREP_DIR=/lustre04/scratch/${USER}/cimaq_fmriprep-20.2.7lts_1687549726/CIMAQ/fmriprep-20.2.7lts/derivatives
GIGA_AUTO_QC_CONTAINER=/home/${USER}/projects/rrg-pbellec/${USER}/giga_preprocess2/giga_auto_qc-0.3.3.simg

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${SCRATCH}:/outputs ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs group
