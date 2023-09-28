#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=1
#SBATCH --array=1-7

source /lustre03/project/6003287/${USER}/.virtualenvs/giga_auto_qc/bin/activate

ABIDE2_FMRIPREP=/lustre04/scratch/${USER}/abide2_fmriprep-20.2.7lts
ABIDE2_CONNECTOME=/lustre04/scratch/${USER}/abide2_connectomes-0.3.0

WORKINGDIR=${ABIDE2_CONNECTOME}/working_directory

STRATEGIES=("simple" "simple+gsr" "scrubbing.5" "scrubbing.5+gsr" "scrubbing.2" "scrubbing.2+gsr" "acompcor50")
STRATEGY=${STRATEGIES[${SLURM_ARRAY_TASK_ID} - 1 ]}
PARTICIPANTS="29580 29584 29588 29592 29596 29601 29605 29609 29613 29617 29621 29626 29630 29634 29581 29585 29589 29593 29597 29602 29606 29610 29614 29618 29627 29631 29635 29582 29586 29590 29594 29598 29603 29607 29611 29615 29619 29624 29628 29632 29583 29587 29591 29595 29600 29604 29608 29612 29616 29620 29625 29629 29633"  # exclude the subject with no cosine regressor

mkdir -p $WORKINGDIR

echo ${ABIDE2_FMRIPREP}/${SITE}/fmriprep-20.2.7lts
if [ -d "${ABIDE2_FMRIPREP}/${SITE}/fmriprep-20.2.7lts" ]; then
    mkdir ${WORKINGDIR}/${SITE}
    mkdir ${ABIDE2_CONNECTOME}/${SITE}
	echo "=========$STRATEGY========="
	echo "${ATLAS}"
	giga_connectome \
		--participant_label $PARTICIPANTS \
		-w ${WORKINGDIR}/${SITE} \
		--atlas ${ATLAS} \
		--denoise-strategy ${STRATEGY} \
		${ABIDE2_FMRIPREP}/${SITE}/fmriprep-20.2.7lts \
		${SLURM_TMPDIR}/${SITE} \
		group
	exitcode=$?  # catch exit code
	if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 $SLURM_TMPDIR/${SITE} ${ABIDE2_CONNECTOME}/ ; fi
else
    echo "no preprocessed data for ${SITE}"
fi
