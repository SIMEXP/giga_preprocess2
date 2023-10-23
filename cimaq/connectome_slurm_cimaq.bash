#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.err
#SBATCH --cpus-per-task=1


GIGA_CONNECTOME_VERSION=0.4.1
SITE=cimaq_test
GIGA_CONNECTOME=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/${DATASET}_fmriprep-20.2.7lts_1687549726/CIMAQ/fmriprep-20.2.7lts/derivatives
CONNECTOME_OUTPUT="/home/nclarke/cimaq_connectomes-0.4.1/"

WORKINGDIR="/home/nclarke/cimaq_connectomes-0.4.1/working_directory/cimaq_test"

module load apptainer/1.1.8

mkdir -p $WORKINGDIR

echo "FMRIPREP_DIR: ${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
	mkdir -p ${SLURM_TMPDIR}
	mkdir -p ${CONNECTOME_OUTPUT}/${SITE}
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
		--calculate-intranetwork-average-correlation \
		/data/input \
		/data/output \
		group
	exitcode=$?  # catch exit code
	if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${CONNECTOME_OUTPUT}/${SITE} ; fi
else
    echo "no preprocessed data for ${SITE}"
fi