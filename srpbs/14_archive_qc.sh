#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc_archive
#SBATCH --output=/home/nclarke/scratch/logs/srpbs_qc_archive.out
#SBATCH --error=/home/nclarke/scratch/logs/srpbs_qc_archive.err
#SBATCH --time=8:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


RAW_PATH="/home/nclarke/scratch/srpbs_qc"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
