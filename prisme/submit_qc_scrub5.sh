#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=prisme_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=6G 

module load apptainer

GIGA_QC_VERSION=0.3.4
FMRIPREP_DIR=/lustre04/scratch/${USER}/prisme.fmriprep
GIGA_AUTO_QC_CONTAINER=/lustre03/project/6003287/containers/giga_auto_qc_unstable_update.simg
QC_OUTPUT=/lustre04/scratch/${USER}/prisme_giga_auto_qc-${GIGA_QC_VERSION}_scrub5
QC_PARAMS=/lustre03/project/rrg-pbellec/${USER}/giga_preprocess2/qc_params_scrub5.json 

mkdir -p $QC_OUTPUT

echo "Running QC"

apptainer run --cleanenv -B ${QC_PARAMS}:/tmp/qc_params_scrub5.json -B ${FMRIPREP_DIR}:/inputs -B ${QC_OUTPUT}:/outputs -B /lustre03:/lustre03 ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs --quality_control_parameters ${QC_PARAMS} group
