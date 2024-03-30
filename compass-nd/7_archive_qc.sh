#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc_archive
#SBATCH --output=/lustre04/scratch/nclarke/logs/compass-nd_qc_archive.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/compass-nd_qc_archive.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


RAW_PATH="/lustre04/scratch/nclarke/compass-nd_giga_auto_qc-0.3.3_scrub.5"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/compass-nd_fmriprep-20.2.7lts"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
