#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc_archive
#SBATCH --output=/lustre07/scratch/nclarke/logs/cimaq_qc_archive.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/cimaq_qc_archive.err
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=1


RAW_PATH="/lustre07/scratch/nclarke/cimaq_giga_auto_qc-0.3.3"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre06/nearline/6035398/nclarke/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
