#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/hwang1/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/%x_%A.out
#SBATCH --cpus-per-task=1


GIGA_CONNECTOME_VERSION=0.4.1

GIGA_CONNECTOME=/lustre03/project/6003287/${USER}/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=${SLURM}/${DATASET}_fmriprep-20.2.7lts/${SITE}
CONNECTOME_OUTPUT=${SLURM}/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}/

WORKINGDIR=${CONNECTOME_OUTPUT}/working_directory/${SITE}

module load apptainer/1.1.8

mkdir -p $WORKINGDIR

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir ${WORKINGDIR}
	mkdir ${SLURM_TMPDIR}
	mkdir ${CONNECTOME_OUTPUT}/${SITE}
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
		/data/input \
		/data/output \
		group
	exitcode=$?  # catch exit code
	if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${CONNECTOME_OUTPUT}/${SITE} ; fi
else
    echo "no preprocessed data for ${SITE}"
fi
