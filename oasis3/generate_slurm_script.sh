#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=oasis3fmriprepslurm
#SBATCH --output=/path/to/your/scratch/logs/%x_%A.out
#SBATCH --error=/path/to/your/scratch/logs/%x_%A.err
#SBATCH --time=6:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.1"
EMAIL=${SLACK_EMAIL_BOT}

module load singularity/3.8
echo "Create fmriprep-slurm scripts for OASIS3"

DATASET_PATH="/lustre04/scratch/${USER}/oasis3"
time=`date +%s`
OUTPUT_PATH="/lustre04/scratch/nclarke/oasis3_fmriprep-${VERSION}lts"
SITES=`ls $DATASET_PATH`

mkdir -p $OUTPUT_PATH

# run BIDS validator on the dataset
# you only need this done once
singularity exec -B ${DATASET_PATH}:/DATA \
    ${CONTAINER_PATH}/fmriprep-20.2.1lts.sif bids-validator /DATA

# running the script from the curre directory, reference
# fmriprep_slurm_singularity_run.bash from one level up
bash ../scripts/fmriprep_slurm_singularity_run.bash \  
    ${OUTPUT_PATH} \
    ${DATASET_PATH} \
    fmriprep-${VERSION}lts \
    --fmriprep-args=\"--use-aroma\" \
    --email=${EMAIL} \
    --time=36:00:00 \
    --mem-per-cpu=12288 \
    --cpus=1 \
    --container fmriprep-${VERSION}lts
