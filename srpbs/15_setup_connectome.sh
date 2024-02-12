#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --output=/lustre07/scratch/nclarke/logs/srpbs_conn/%x_%A.out
#SBATCH --error=/lustre07/scratch/nclarke/logs/srpbs_conn/%x_%A.err
#SBATCH --cpus-per-task=1
#SBATCH --time=36:00:00
#SBATCH --mem=12G

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME="/home/nclarke/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg"
FMRIPREP_DIR="/home/nclarke/scratch/srpbs_fmriprep-20.2.7lts_1691842839/data/fmriprep-20.2.7lts/derivatives"
CONNECTOME_OUTPUT="/lustre07/scratch/nclarke/srpbs_connectomes-${GIGA_CONNECTOME_VERSION}"
WORKINGDIR="${CONNECTOME_OUTPUT}/working_directory"

module load apptainer

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
	mkdir -p ${SLURM_TMPDIR}
    mkdir -p ${CONNECTOME_OUTPUT}
	echo "Running group level connectome"
	apptainer run \
		--bind ${FMRIPREP_DIR}:/data/input \
		--bind ${SLURM_TMPDIR}:/data/output \
		${GIGA_CONNECTOME} \
		--reindex-bids \
		--atlas MIST \
		--denoise-strategy simple \
		/data/input \
		/data/output \
		group
	exitcode=$?  # catch exit code
	if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${CONNECTOME_OUTPUT} ; fi
else
    echo "no preprocessed data for ${DATASET}"
fi