#!/bin/bash

FMRIPREP_PATH="/lustre04/scratch/hwang1/abide2_fmriprep-20.2.7lts"
SITES=`ls $FMRIPREP_PATH`

for site in ${SITES}; do
    sbatch \
        --time=2:00:00 --mem-per-cpu=8G \
        --job-name=abide2_connectome_${site}_Schaefer20187Networks \
        --export=ATLAS="Schaefer20187Networks",SITE=$site \
        ./connectome_slurm_abide2.bash
    sbatch \
        --time=2:00:00 --mem-per-cpu=8G \
        --job-name=abide2_connectome_${site}_MIST \
        --export=ATLAS="MIST",SITE=$site \
        ./connectome_slurm_abide2.bash
    sbatch \
        --time=2:00:00 --mem-per-cpu=32G \
        --job-name=abide2_connectome_${site}_DiFuMo \
        --export=ATLAS="DiFuMo",SITE=$site \
        ./connectome_slurm_abide2.bash
done

FMRIPREP_PATH="/lustre04/scratch/hwang1/abide1_fmriprep-20.2.7lts"
SITES=`ls $FMRIPREP_PATH`

for site in ${SITES}; do
    sbatch \
        --time=2:00:00 --mem-per-cpu=8G \
        --job-name=abide1_connectome_${site}_Schaefer20187Networks \
        --export=ATLAS="Schaefer20187Networks",SITE=$site \
        ./connectome_slurm_abide.bash
    sbatch \
        --time=2:00:00 --mem-per-cpu=8G \
        --job-name=abide1_connectome_${site}_MIST \
        --export=ATLAS="MIST",SITE=$site \
        ./connectome_slurm_abide.bash
    sbatch --array-task=2 \
        --time=2:00:00 --mem-per-cpu=32G \
        --job-name=abide1_connectome_${site}_DiFuMo \
        --export=ATLAS="DiFuMo",SITE=$site \
        ./connectome_slurm_abide.bash
done
