#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=conn_archive
#SBATCH --output=/lustre07/scratch/nclarke/logs/oasis_conn_archive.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/oasis_conn_archive.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G


RAW_PATH="/home/nclarke/scratch/oasis3_connectomes-0.4.1"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre06/nearline/6035398/nclarke/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vczf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
