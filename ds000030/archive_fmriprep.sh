#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=fmriprep_archive
#SBATCH --output=/lustre04/scratch/hwang1/logs/ds000030_fmriprep_archive.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/ds000030_fmriprep_archive.%a.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


FMRIPREP_PATH="/lustre04/scratch/hwang1/ds000030_fmriprep-20.2.1lts"
DATASET_NAME=`basename $FMRIPREP_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${FMRIPREP_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
