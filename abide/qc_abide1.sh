#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=abide1_qc
#SBATCH --output=/lustre04/scratch/hwang1/logs/abide1_qc.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/abide1_qc.%a.out
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --array=1-24

source /lustre03/project/6003287/${USER}/.virtualenvs/giga_auto_qc/bin/activate

FMRIPREP_PATH=/lustre04/scratch/${USER}/abide1_fmriprep-20.2.7lts
QC_OUTPUT=/lustre04/scratch/${USER}/abide1_qc
SITES=("Caltech" "CMU_a" "CMU_b" "KKI" "Leuven_1" "Leuven_2" "MaxMun_a" "MaxMun_b" "MaxMun_c" "MaxMun_d" "NYU" "OHSU" "Olin" "Pitt" "SBL" "SDSU" "Stanford" "Trinity" "UCLA_1" "UCLA_2" "UM_1" "UM_2" "USM" "Yale")

SITE=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}

mkdir -p $QC_OUTPUT

echo ${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts
if [ -d "${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts" ]; then
    mkdir -p ${QC_OUTPUT}/${SITE}
    # rm ${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts/layout_index.sqlite
    giga_auto_qc \
        ${FMRIPREP_PATH}/${SITE}/fmriprep-20.2.7lts \
        ${QC_OUTPUT}/${SITE} \
		group
else
    echo "no preprocessed data for ${SITE}"
fi

