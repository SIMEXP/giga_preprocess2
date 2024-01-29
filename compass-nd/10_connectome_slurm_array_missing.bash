#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --cpus-per-task=1

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/compass-nd_fmriprep-20.2.7lts/bids_release_7/fmriprep-20.2.7lts
CONNECTOME_OUTPUT=/lustre04/scratch/${USER}/compass-nd_connectome-${GIGA_CONNECTOME_VERSION}
WORKINGDIR="${CONNECTOME_OUTPUT}/working_directory"

module load apptainer

mkdir -p $WORKINGDIR

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})
PARTICIPANT_OUTPUT="${CONNECTOME_OUTPUT}/${PARTICIPANT_LABEL}"

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
        mkdir -p ${SLURM_TMPDIR}
        mkdir -p ${PARTICIPANT_OUTPUT}
        echo "Running ${PARTICIPANT_LABEL} connectomes"
        echo "=========${STRATEGY}========="
        echo "${ATLAS}"
        apptainer run \
                --bind ${FMRIPREP_DIR}:/data/input \
                --bind ${SLURM_TMPDIR}:/data/output \
                --bind ${WORKINGDIR}:/data/working \
                ${GIGA_CONNECTOME} \
                -w /data/working \
                --atlas ${ATLAS} \
                --denoise-strategy ${STRATEGY} \
                ${INTRANETWORK_FLAG} \
                /data/input \
                /data/output \
                participant \
        --participant_label ${PARTICIPANT_LABEL}
        exitcode=$?  # catch exit code
        if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${PARTICIPANT_OUTPUT} ; fi
else
    echo "no preprocessed data for ${DATASET}"
fi