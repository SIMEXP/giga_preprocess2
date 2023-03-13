#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=1
#SBATCH --array=1-8

source /lustre03/project/6003287/${USER}/.virtualenvs/giga_connectome/bin/activate

ABIDE2_FMRIPREP=/lustre04/scratch/${USER}/abide2_fmriprep-20.2.1lts_1667762103
ABIDE2_CONNECTOME=/lustre04/scratch/${USER}/abide2_connectomes
WORKINGDIR=${ABIDE2_CONNECTOME}/working_directory

STRATEGIES=("simple" "simple+gsr" "scrubbing.5" "scrubbing.5+gsr" "scrubbing.2" "scrubbing.2+gsr" "acompcor50" "icaaroma")
STRATEGY=${STRATEGIES[${SLURM_ARRAY_TASK_ID} - 1 ]}

mkdir -p $WORKINGDIR

echo ${ABIDE2_FMRIPREP}/${SITE}/fmriprep-20.2.1lts
if [ -d "${ABIDE2_FMRIPREP}/${SITE}/fmriprep-20.2.1lts" ]; then
    mkdir ${WORKINGDIR}/${SITE}
    mkdir ${ABIDE2_CONNECTOME}/${SITE}
	echo "=========$STRATEGY========="
	echo "${ATLAS}"
	giga_connectome \
		-w ${WORKINGDIR}/${SITE} \
		--atlas ${ATLAS} \
		--denoise-strategy ${STRATEGY} \
		${ABIDE2_FMRIPREP}/${SITE}/fmriprep-20.2.1lts \
		${SLURM_TMPDIR}/${SITE} \
		group
	rsync -rltv --info=progress2 $SLURM_TMPDIR/${SITE} ${ABIDE2_CONNECTOME}/
else
    echo "no preprocessed data for ${SITE}"
fi

