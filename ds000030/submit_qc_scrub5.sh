#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=ds000030_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G

module load apptainer

GIGA_QC_VERSION=0.3.3
FMRIPREP_DIR=/lustre04/scratch/${USER}/ds000030_fmriprep-20.2.7lts_1686276519/ds000030/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/lustre03/project/rrg-pbellec/${USER}/giga_preprocess2/giga_auto_qc-${GIGA_QC_VERSION}.simg
QC_OUTPUT=/lustre04/scratch/${USER}/ds000030_giga_auto_qc-${GIGA_QC_VERSION}_scrub.5
QC_PARAMS=/lustre03/project/rrg-pbellec/${USER}/giga_preprocess2/qc_params_scrub5.json

mkdir -p $QC_OUTPUT

echo "Running QC"

apptainer run --cleanenv -B ${QC_PARAMS} -B ${FMRIPREP_DIR}:/inputs -B ${QC_OUTPUT}:/outputs ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs --quality_control_parameters ${QC_PARAMS} group
