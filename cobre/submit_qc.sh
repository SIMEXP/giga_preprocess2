#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cobre_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/cobre_qc.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cobre_qc.%a.err
#SBATCH --time=23:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

# Load the apptainer module
module load apptainer

SINGULARITY_IMAGE=/lustre04/scratch/${USER}/giga_auto_qc-0.3.2.simg
FMRIPREP_PATH=/lustre04/scratch/${USER}/cobre/COBRE

echo ${FMRIPREP_PATH}
if [ -d "${FMRIPREP_PATH}/fmriprep-20.2.7lts" ]; then
    mkdir -p ${FMRIPREP_PATH}/cobre_qc
    apptainer run --cleanenv -B ${FMRIPREP_PATH}:/DATA \
    ${SINGULARITY_IMAGE} \
    /DATA/fmriprep-20.2.7lts\
    /DATA/cobre_qc \
    group \
    --reindex-bids

else
    echo "no preprocessed data for ${FMRIPREP_PATH}"
fi
