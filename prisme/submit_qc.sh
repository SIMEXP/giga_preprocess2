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
FMRIPREP_DIR=/lustre03/project/6003287/${USER}/prisme.fmriprep
GIGA_AUTO_QC_CONTAINER=/lustre03/project/6003287/containers/giga_auto_qc_unstable_update.simg
QC_OUTPUT=/lustre04/scratch/${USER}/prisme_giga_auto_qc-${GIGA_QC_VERSION}_20241029 

mkdir -p $QC_OUTPUT

echo "Running QC"

apptainer run --cleanenv -B ${FMRIPREP_DIR}:/inputs -B ${QC_OUTPUT}:/outputs -B /lustre03:/lustre03 ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs  group
