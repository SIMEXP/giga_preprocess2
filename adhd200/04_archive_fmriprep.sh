#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=fmriprep_archive
#SBATCH --output=/lustre04/scratch/hwang1/logs/fmriprep_archive.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/fmriprep_archive.%a.out
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-10


FMRIPREP_PATH="/lustre04/scratch/hwang1/adhd200_fmriprep-20.2.7lts"
SITES=(`ls $FMRIPREP_PATH`)
DATASET_NAME=`basename $FMRIPREP_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

site=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}
echo $site
cd ${FMRIPREP_PATH}/${site}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${site}.tar .
