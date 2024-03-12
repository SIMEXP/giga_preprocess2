#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=oasis_qc
#SBATCH --output=/lustre04/scratch/nclarke/logs/oasis_qc.%a.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/oasis_qc.%a.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

source /lustre03/project/6003287/nclarke/.virtualenvs/giga_auto_qc/bin/activate

FMRIPREP_PATH=/home/nclarke/scratch/oasis3_fmriprep-20.2.7lts_1689714556/oasis3_bids
QC_OUTPUT=/lustre04/scratch/${USER}/oasis_qc

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
