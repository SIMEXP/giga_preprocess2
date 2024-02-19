#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=conn_archive
#SBATCH --output=/home/nclarke/scratch/logs/adni_conn_archive.out
#SBATCH --error=/home/nclarke/scratch/logs/adni_conn_archive.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


RAW_PATH="/lustre04/scratch/${USER}/adni_connectomes-0.4.1"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/adni_fmriprep-20.2.7lts_1682352545/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
