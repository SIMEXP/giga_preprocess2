#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cobre_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/cobre_qc.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cobre_qc.%a.err
#SBATCH --time=00:42:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G

source /lustre03/project/6003287/${USER}/.virtualenvs/giga_auto_qc/bin/activate

FMRIPREP_PATH=/lustre04/scratch/${USER}/COBRE
QC_OUTPUT=/lustre04/scratch/${USER}/cobre_qc

mkdir -p $QC_OUTPUT

echo ${FMRIPREP_PATH}
if [ -d "${FMRIPREP_PATH}/fmriprep-20.2.7lts" ]; then
    mkdir -p ${QC_OUTPUT}
    rm ${FMRIPREP_PATH}/fmriprep-20.2.7lts/layout_index.sqlite
    giga_auto_qc \
        ${FMRIPREP_PATH}/fmriprep-20.2.7lts \
        ${QC_OUTPUT} \
		participant

else
    echo "no preprocessed data for ${FMRIPREP_PATH}"
fi
