#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=conn_archive
#SBATCH --output=/home/nclarke/scratch/logs/srpbs_conn_archive.out
#SBATCH --error=/home/nclarke/scratch/logs/srpbs_conn_archive.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G


RAW_PATH="/home/nclarke/scratch//home/nclarke/scratch/srpbs_connectome-0.4.1_MIST_afc
"
DATASET_NAME=`basename $RAW_PATH`

ARCHIVE_PATH="/home/nclarke/nearline/ctb-pbellec/giga_preprocessing_2/srpbs_fmriprep-20.2.7lts_1691842839/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

cd ${RAW_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
