#!/bin/bash
#SBATCH --job-name=fmriprep_get_archive
#SBATCH --output=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/%x_%A.%a.out
#SBATCH --time=6:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G

NEARLINE_ARCHIVE="/lustre03/nearline/6035398/giga_preprocessing_2/ds000030_fmriprep-20.2.1lts"
FMRIPREP_FILENAME="ds000030_fmriprep-20.2.1lts_1651688951"

cd /lustre04/scratch/${USER}/
# untar to scratch
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/dataset_description.json'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/desc-*_dseg.tsv'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin2009cAsym_desc-preproc_bold.*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin2009cAsym_desc-brain_mask*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_space-MNI152NLin6Asym_desc-brain_mask*'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_desc-MELODIC_mixing.tsv'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_AROMAnoiseICs.csv'
tar xvf ${NEARLINE_ARCHIVE}/${FMRIPREP_FILENAME}.tar.gz --wildcards --no-anchored './fmriprep-20.2.1lts/sub-*/func/*_desc-confounds_timeseries*'

echo "===========finished==========="