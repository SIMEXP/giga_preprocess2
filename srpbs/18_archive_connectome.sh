#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=conn_archive
#SBATCH --output=/lustre07/scratch/nclarke/logs/srpbs_conn_archive.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/srpbs_conn_archive.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G


RAW_PATH="/home/nclarke/scratch//home/nclarke/scratch/srpbs_connectome-0.4.1_MIST_afc
"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre06/nearline/6035398/nclarke/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vczf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
