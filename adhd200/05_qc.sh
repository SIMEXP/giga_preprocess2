#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=auto_qc
#SBATCH --output=/lustre04/scratch/hwang1/logs/auto_qc.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/auto_qc.%a.out
#SBATCH --time=6:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-10

DATASET=adhd200
GIGA_AUTO_QC_VERSION=0.3.4
SITES=(`ls ${SCRATCH}/${DATASET}_fmriprep-20.2.7lts/`)
SITE=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}

CONTAINER=/lustre03/project/6003287/containers/giga_auto_qc-${GIGA_AUTO_QC_VERSION}.simg
FMRIPREP_DIR=${SCRATCH}/${DATASET}_fmriprep-20.2.7lts/${SITE}/fmriprep-20.2.7lts
QC_OUTPUT=${SCRATCH}/${DATASET}_giga-auto-qc-${GIGA_AUTO_QC_VERSION}/

module load apptainer/1.1.8

mkdir -p $QC_OUTPUT

echo ${FMRIPREP_DIR}
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${QC_OUTPUT}/${SITE}
    rm ${FMRIPREP_DIR}/layout_index.sqlite*
    echo "Running giga_auto_qc for ${SITE}"
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
    echo "no preprocessed data for 05_qc.sh${SITE}"
fi
