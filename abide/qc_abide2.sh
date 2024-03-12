#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=abide2_qc
#SBATCH --output=/lustre04/scratch/hwang1/logs/abide2_qc.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/abide2_qc.%a.out
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --array=1-24

GIGA_AUTO_QC_VERSION=0.3.3
DATASET=abide2
SITE=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}

CONTAINER=/lustre03/project/6003287/${USER}/giga_auto_qc-${GIGA_AUTO_QC_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/${DATASET}_fmriprep-20.2.7lts/${SITE}
QC_OUTPUT=/lustre04/scratch/${USER}/${DATASET}_giga-auto-qc-${GIGA_AUTO_QC_VERSION}/

module load apptainer/1.1.8

mkdir -p $QC_OUTPUT

echo ${FMRIPREP_DIR}
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${QC_OUTPUT}/${SITE}
    apptainer run \
        --bind ${FMRIPREP_DIR}:/data/input \
        --bind ${QC_OUTPUT}/${SITE}:/data/output \
        ${CONTAINER} \
        --reindex-bids \
        /data/input \
	/data/output \
	group
    exitcode=$?  # catch exit code
else
    echo "no preprocessed data for ${SITE}"
fi

