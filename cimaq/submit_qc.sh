#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=cimaq_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/cimaq_qc.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cimaq_qc.%a.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

source /lustre03/project/6003287/nclarke/.virtualenvs/giga_auto_qc/bin/activate

FMRIPREP_PATH=/home/nclarke/scratch/cimaq_fmriprep-20.2.7lts_1687549726/CIMAQ
QC_OUTPUT=/lustre04/scratch/${USER}/cimaq_qc

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
