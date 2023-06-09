#!/bin/bash
# Most jobs can be done within 2 hours.
# Manually changed for NYC to 6 hours for difumo and 3 for the other 2
#

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
    sbatch \
        --time=2:00:00 --mem-per-cpu=32G \
        --job-name=abide1_connectome_${site}_DiFuMo \
        --export=ATLAS="DiFuMo",SITE=$site \
        ./connectome_slurm_abide.bash
done
