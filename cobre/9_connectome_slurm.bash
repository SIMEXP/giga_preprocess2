#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.err
#SBATCH --cpus-per-task=1

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/cobre_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts
CONNECTOME_OUTPUT=/lustre04/scratch/${USER}/${DATASET}_connectome-${GIGA_CONNECTOME_VERSION}

WORKINGDIR=${CONNECTOME_OUTPUT}/working_directory

module load apptainer

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
	mkdir -p ${SLURM_TMPDIR}
	mkdir -p ${CONNECTOME_OUTPUT}
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
		group
	exitcode=$?  # catch exit code
	if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${CONNECTOME_OUTPUT} ; fi
else
    echo "no preprocessed data for ${DATASET}"
fi
