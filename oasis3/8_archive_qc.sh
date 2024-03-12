#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc_archive
#SBATCH --output=/lustre07/scratch/nclarke/logs/qc_archive.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/qc_archive.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=1


RAW_PATH="/home/nclarke/scratch/oasis3_giga_auto_qc_participant-0.3.3"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre06/nearline/6035398/nclarke/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
