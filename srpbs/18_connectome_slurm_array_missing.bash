#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --output=/lustre07/scratch/nclarke/logs/srpbs_conn/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/srpbs_conn/%x_%A.out
#SBATCH --cpus-per-task=1

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME="/home/nclarke/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg"
FMRIPREP_DIR="/home/nclarke/scratch/srpbs_fmriprep-20.2.7lts_1691842839/data/fmriprep-20.2.7lts/derivatives"
CONNECTOME_OUTPUT="/lustre07/scratch/nclarke/srpbs_connectomes-${GIGA_CONNECTOME_VERSION}"
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
