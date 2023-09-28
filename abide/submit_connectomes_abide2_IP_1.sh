#!/bin/bash

FMRIPREP_PATH="/lustre04/scratch/hwang1/abide2_fmriprep-20.2.7lts"
site=IP_1

sbatch \
    --time=0:30:00 --mem-per-cpu=8G \
    --job-name=abide2_connectome_${site}_Schaefer20187Networks \
    --export=ATLAS="Schaefer20187Networks",SITE=$site \
    ./connectome_slurm_abide2_IP_1.bash
sbatch \
    --array=2,4 \
    --time=1:00:00 --mem-per-cpu=8G \
    --job-name=abide2_connectome_${site}_MIST \
    --export=ATLAS="MIST",SITE=$site \
    ./connectome_slurm_abide2_IP_1.bash
sbatch \
    --array=3-5,7 \
    --time=3:00:00 --mem-per-cpu=32G \
    --job-name=abide2_connectome_${site}_DiFuMo \
    --export=ATLAS="DiFuMo",SITE=$site \
    ./connectome_slurm_abide2_IP_1.bash
