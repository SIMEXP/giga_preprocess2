#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=abide1_fmriprep_archive
#SBATCH --output=/lustre04/scratch/hwang1/logs/abide1_fmriprep_archive.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/abide1_fmriprep_archive.%a.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-18


FMRIPREP_PATH="/lustre04/scratch/hwang1/abide1_fmriprep-20.2.1lts_1677784848"
SITES=("CMU_a" "CMU_b" "KKI" "Leuven_1" "Leuven_2" "MaxMun_a" "MaxMun_b" "NYU" "OHSU" "Olin" "Pitt" "SBL" "Stanford" "Trinity" "UCLA_1" "UCLA_2" "USM" "Yale")
# UM_1 UM_2 SDSU MaxMun_c MaxMun_d Caltech
DATASET_NAME=`basename $FMRIPREP_PATH`

ARCHIVE_PATH="/lustre03/nearline/6035398/giga_preprocessing_2/${DATASET_NAME}"

mkdir -p $ARCHIVE_PATH

site=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}
echo $site
cd ${FMRIPREP_PATH}/${site}
echo $PWD
tar -vcf ${ARCHIVE_PATH}/${site}.tar.gz .