#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --time=6:00:00
#SBATCH --cpus-per-task=1
#SBATCH --array=1-8

STRATEGIES=("simple" "simple+gsr" "scrubbing.5" "scrubbing.5+gsr" "scrubbing.2" "scrubbing.2+gsr" "acompcor50" "icaaroma")
STRATEGY=${STRATEGIES[${SLURM_ARRAY_TASK_ID} - 1 ]}

source /lustre03/project/6003287/${USER}/.virtualenvs/giga_connectome/bin/activate

NEARLINE_ARCHIVE="/lustre03/nearline/6035398/giga_preprocessing_2/ds000030_fmriprep-20.2.1lts"
FMRIPREP_FILENAME="ds000030_fmriprep-20.2.1lts_1651688951"
OUTPUT_CONNECTOME=/lustre04/scratch/${USER}/ds000030_connectomes
WORKINGDIR=${OUTPUT_CONNECTOME}/working_directory

cd /lustre04/scratch/${USER}/
# untar to scratch
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin2009cAsym_desc-preproc_bold.*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin2009cAsym_desc-brain_mask*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin6Asym_desc-brain_mask*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_desc-MELODIC_mixing.tsv'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_AROMAnoiseICs.csv'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_desc-confounds_timeseries*'

# run connectome workflow
mkdir -p ${WORKINGDIR}
mkdir /lustre04/scratch/${USER}/ds000030_connectomes
echo "=========$STRATEGY========="
echo "${ATLAS}"
giga_connectome \
    -w ${WORKINGDIR} \
    --atlas ${ATLAS} \
    --denoise-strategy ${STRATEGY} \
    ${SLURM_TMPDIR}/fmriprep-20.2.1lts \
    ${SLURM_TMPDIR}/ds000030_connectomes \
    group

exitcode=$?  # catch exit code

# copy connectome and the working directory to my own scratch 
if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/ds000030_connectomes ${OUTPUT_CONNECTOME}/ ; fi
