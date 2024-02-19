#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=conn_archive
#SBATCH --output=/lustre04/scratch/nclarke/logs/compass-nd_conn_archive.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/compass-nd_conn_archive.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


CONNECTOME_PATH="/lustre04/scratch/${USER}/compass-nd_connectome-0.4.1"
DATASET_NAME=`basename $CONNECTOME_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/compass-nd_fmriprep-20.2.7lts"

cd ${CONNECTOME_PATH}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${DATASET_NAME}.tar.gz .
