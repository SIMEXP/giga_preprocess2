#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=prisme_conn
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.err
#SBATCH --cpus-per-task=1
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=36G

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME=/lustre03/project/6003287/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/prisme.fmriprep
CONNECTOME_OUTPUT=/lustre04/scratch/${USER}/prisme_connectome-${GIGA_CONNECTOME_VERSION}_BA
WORKINGDIR=${CONNECTOME_OUTPUT}/working_directory
ATLAS_CONFIG=/lustre03/project/6003287/${USER}/brainnetome.json
ATLAS_PATH=/home/${USER}/.cache/templateflow
export APPTAINERENV_TEMPLATEFLOW_HOME=/templateflow

module load apptainer

mkdir -p ${WORKINGDIR}

echo "${FMRIPREP_DIR}"
if [ -d "${FMRIPREP_DIR}" ]; then
    mkdir -p ${WORKINGDIR}
	mkdir -p ${SLURM_TMPDIR}
	mkdir -p ${CONNECTOME_OUTPUT}/
	echo "=========${STRATEGY}========="
	apptainer run \
	    --bind ${FMRIPREP_DIR}:/data/input \
	    --bind ${SLURM_TMPDIR}:/data/output \
	    --bind ${WORKINGDIR}:/data/working \
	    --bind ${ATLAS_CONFIG}:/data/brainnetome.json \
	    --bind ${ATLAS_PATH}:/templateflow \
	    -B /lustre03:/lustre03 \
	    ${GIGA_CONNECTOME} \
	    --reindex-bids \
	    -w /data/working \
       	--atlas /data/brainnetome.json \
	    --denoise-strategy simple+gsr \
        /data/input \
	    /data/output \
	    group
	exitcode=$?  # catch exit code
	if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${CONNECTOME_OUTPUT} ; fi
else
    echo "no preprocessed data for ${FMRIPREP_DIR}"
fi
