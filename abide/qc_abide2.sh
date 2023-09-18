#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=abide2_qc
#SBATCH --output=/lustre04/scratch/hwang1/logs/abide2_qc.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/abide2_qc.%a.out
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --array=1-24

source /lustre03/project/6003287/${USER}/.virtualenvs/giga_auto_qc/bin/activate

FMRIPREP_PATH=/lustre04/scratch/${USER}/abide2_fmriprep-20.2.7lts
QC_OUTPUT=/lustre04/scratch/${USER}/abide2_giga-auto-qc-0.3.1
SITES=(`ls $FMRIPREP_PATH`)

SITE=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}

mkdir -p $QC_OUTPUT

echo ${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts
if [ -d "${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts" ]; then
    mkdir -p ${QC_OUTPUT}/${SITE}
    rm ${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts/layout_index.sqlite
    giga_auto_qc \
        ${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts \
        ${QC_OUTPUT}/${SITE} \
		group
else
    echo "no preprocessed data for ${SITE}"
fi
