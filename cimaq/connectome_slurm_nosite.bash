#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.err
#SBATCH --cpus-per-task=1


GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/${DATASET}_fmriprep-20.2.7lts_1687549726/CIMAQ/fmriprep-20.2.7lts/derivatives
CONNECTOME_OUTPUT="/home/nclarke/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}"

WORKINGDIR="${CONNECTOME_OUTPUT}/working_directory"

module load apptainer/1.1.8

mkdir -p $WORKINGDIR

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
	mkdir -p ${CONNECTOME_OUTPUT}
	echo "=========${STRATEGY}========="
	echo "${ATLAS}"
	apptainer run \
		--bind ${FMRIPREP_DIR}:/data/input \
		--bind ${CONNECTOME_OUTPUT}:/data/output \
		--bind ${WORKINGDIR}:/data/working \
		${GIGA_CONNECTOME} \
		-w /data/working \
		--atlas ${ATLAS} \
		--denoise-strategy ${STRATEGY} \
		--reindex-bids \
		--calculate-intranetwork-average-correlation \
		/data/input \
		/data/output \
		group
else
    echo "no preprocessed data for ${DATASET}"
fi
