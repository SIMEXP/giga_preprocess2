#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --output=/lustre07/scratch/nclarke/logs/cimaq_conn/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/cimaq_conn/%x_%A.err
#SBATCH --cpus-per-task=1
#SBATCH --array=1-246

GIGA_CONNECTOME="/home/nclarke/giga_connectome-0.4.1.simg"
FMRIPREP_DIR="/home/nclarke/scratch/cimaq_fmriprep-20.2.7lts_1687549726/CIMAQ/fmriprep-20.2.7lts/derivatives"
CONNECTOME_OUTPUT="/home/nclarke/scratch/cimaq_connectomes-0.4.1"
participant_labels="/home/nclarke/participant_labels.txt" # One subject number per line

WORKINGDIR="/home/nclarke/scratch/cimaq_connectomes-0.4.1/working_directory"

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

