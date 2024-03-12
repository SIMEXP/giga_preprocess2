#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc
#SBATCH --output=/lustre07/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/%x_%A.out
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

module load apptainer

FMRIPREP_DIR=/lustre07/scratch/${USER}/cobre_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts
GIGA_AUTO_QC_CONTAINER=/home/${USER}/giga_auto_qc-0.3.3.simg
QC_OUTPUT=/lustre07/scratch/${USER}/cobre_giga_auto_qc-0.3.3_scrub0.5
QC_PARAMS=/home/${USER}/qc_params_scrub5.json

mkdir -p $QC_OUTPUT

echo "Running QC"

apptainer run --cleanenv -B ${QC_PARAMS} -B ${FMRIPREP_DIR}:/inputs -B ${QC_OUTPUT}:/outputs ${GIGA_AUTO_QC_CONTAINER} --reindex-bids /inputs /outputs --quality_control_parameters ${QC_PARAMS} group
