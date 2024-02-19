#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=qc_archive
#SBATCH --output=/home/nclarke/scratch/logs/adni_qc_archive.out
#SBATCH --error=/home/nclarke/scratch/logs/adni_qc_archive.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1

# Directory to be archived
RAW_PATH="/lustre04/scratch/${USER}/adni_giga_auto_qc-0.3.3_participant"
DATASET_NAME=$(basename $RAW_PATH)

# Destination path for the archive
ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/adni_fmriprep-20.2.7lts_1682352545"

# Ensure the destination directory exists
mkdir -p $ARCHIVE_PATH

# Navigate to the parent directory of RAW_PATH
cd $(dirname $RAW_PATH)

# Tar the directory
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz ${DATASET_NAME}

