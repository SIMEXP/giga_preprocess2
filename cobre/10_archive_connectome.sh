#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=conn_archive
#SBATCH --output=/home/nclarke/scratch/logs/cobre_conn_archive.out
#SBATCH --error=/home/nclarke/scratch/logs/cobre_conn_archive.err
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1

RAW_PATH="/home/nclarke/scratch/cobre_connectome-0.4.1"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/cobre_fmriprep-20.2.7lts_1683063932/${DATASET_NAME}.tar.gz"

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH} .
