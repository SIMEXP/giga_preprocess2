#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=fmriprep_archive
#SBATCH --output=/lustre04/scratch/nclarke/logs/cobre_fmriprep_archive.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/cobre_fmriprep_archive.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


FMRIPREP_PATH="/lustre04/scratch/${USER}/cobre_fmriprep-20.2.7lts_1683063932"
DATASET_NAME=`basename $FMRIPREP_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${FMRIPREP_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
