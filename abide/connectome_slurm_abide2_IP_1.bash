#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/hwang1/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/%x_%A.out
#SBATCH --cpus-per-task=1


GIGA_CONNECTOME_VERSION=0.4.1
SITE=IP_1
GIGA_CONNECTOME=/lustre03/project/6003287/${USER}/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/${DATASET}_fmriprep-20.2.7lts/${SITE}
CONNECTOME_OUTPUT=/lustre04/scratch/${USER}/${DATASET}_connectomes-${GIGA_CONNECTOME_VERSION}/

WORKINGDIR=${CONNECTOME_OUTPUT}/working_directory/${SITE}

PARTICIPANTS="29580 29584 29588 29592 29596 29601 29605 29609 29613 29617 29621 29626 29630 29634 29581 29585 29589 29593 29597 29602 29606 29610 29614 29618 29627 29631 29635 29582 29586 29590 29594 29598 29603 29607 29611 29615 29619 29624 29628 29632 29583 29587 29591 29595 29600 29604 29608 29612 29616 29620 29625 29629 29633"  # exclude the subject with no cosine regressor

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
		--participant_label ${PARTICIPANTS} \
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
