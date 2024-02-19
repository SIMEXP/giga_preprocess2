#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=raw_archive
#SBATCH --output=/home/nclarke/scratch/logs/cimaq_raw_archive.out
#SBATCH --error=/home/nclarke/scratch//logs/cimaq_raw_archive.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


RAW_PATH="/lustre04/scratch/nclarke/CIMAQ"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/raw/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
