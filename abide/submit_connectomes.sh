#!/bin/bash

FMRIPREP_PATH="/lustre04/scratch/hwang1/abide2_fmriprep-20.2.1lts_1667762103"
SITES=`ls $FMRIPREP_PATH`

for site in ${SITES}; do
    sbatch \
        --time=6:00:00 --mem-per-cpu=8G \
        --job-name=abide2_connectome_${site}_Schaefer20187Networks \
        --mail-user=${SLACK_EMAIL_BOT} \
        --export=ATLAS="Schaefer20187Networks",SITE=$site \
            ./connectome_slurm_run.bash
    sbatch \
        --time=6:00:00 --mem-per-cpu=8G \
        --job-name=abide2_connectome_${site}_MIST \
        --mail-user=${SLACK_EMAIL_BOT} \
        --export=ATLAS="MIST",SITE=$site \
            ./connectome_slurm_run.bash
    sbatch \
        --time=12:00:00 --mem-per-cpu=32G \
        --job-name=abide2_connectome_${site}_DiFuMo \
        --mail-user=${SLACK_EMAIL_BOT} \
        --export=ATLAS="DiFuMo",SITE=$site \
            ./connectome_slurm_run.bash
done