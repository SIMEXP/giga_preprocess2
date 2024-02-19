#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/nclarke/logs/adni_conn/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/adni_conn/%x_%A.out
#SBATCH --cpus-per-task=1
#SBATCH --array=1-747

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME="/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg"
FMRIPREP_DIR="/lustre04/scratch/nclarke/adni_fmriprep-20.2.7lts_1682352545/adni_bids_output_func/fmriprep-20.2.7lts"
CONNECTOME_OUTPUT="/home/nclarke/scratch/adni_connectomes-0.4.1"
participant_labels="/home/nclarke/projects/rrg-pbellec/nclarke/giga_preprocess2/adni/participant_labels.txt" # One subject number per line

WORKINGDIR="/home/nclarke/scratch/adni_connectomes-0.4.1/working_directory"

module load apptainer

mkdir -p $WORKINGDIR

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})
PARTICIPANT_OUTPUT="${CONNECTOME_OUTPUT}/${PARTICIPANT_LABEL}"

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
	mkdir -p ${SLURM_TMPDIR}
    mkdir -p ${CONNECTOME_OUTPUT}
	mkdir -p ${PARTICIPANT_OUTPUT}
	echo "Running ${PARTICIPANT_LABEL} connectomes"
	echo "=========${STRATEGY}========="
	echo "${ATLAS}"
	apptainer run \
		--bind ${FMRIPREP_DIR}:/data/input \
		--bind ${SLURM_TMPDIR}:/data/output \
		${GIGA_CONNECTOME} \
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
