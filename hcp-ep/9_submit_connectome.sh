#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --job-name=hcp_connectome
#SBATCH --output=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --error=/lustre04/scratch/nclarke/logs/%x_%A.out
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=56G
#SBATCH --array=1-180

GIGA_CONNECTOME_VERSION=0.4.1
GIGA_CONNECTOME=/home/${USER}/projects/rrg-pbellec/containers/giga_connectome-${GIGA_CONNECTOME_VERSION}.simg
FMRIPREP_DIR=/lustre04/scratch/${USER}/hcp-ep_fmriprep-20.2.7lts/imagingcollection01/fmriprep-20.2.7lts
CONNECTOME_OUTPUT=/lustre04/scratch/${USER}/hcp-ep_connectome-${GIGA_CONNECTOME_VERSION}
WORKINGDIR=${CONNECTOME_OUTPUT}/working_directory
participant_labels=/lustre03/project/rrg-pbellec/${USER}/giga_preprocess2/hcp-ep/participant_labels.txt # One subject number per line

module load apptainer

PARTICIPANT_LABEL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${participant_labels})
PARTICIPANT_OUTPUT="${CONNECTOME_OUTPUT}/${PARTICIPANT_LABEL}"

mkdir -p $WORKINGDIR

# Create participant-specific directory
mkdir -p ${PARTICIPANT_OUTPUT}

# Define strategies and atlases
STRATEGIES=("acompcor50" "simple" "simple+gsr" "scrubbing.2" "scrubbing.2+gsr" "scrubbing.5" "scrubbing.5+gsr")
ATLASES=("Schaefer20187Networks" "MIST" "DiFuMo")

# Loop through each strategy and atlas
for STRATEGY in "${STRATEGIES[@]}"; do
    for ATLAS in "${ATLASES[@]}"; do
        # Set AFC flag based on atlas
        if [[ "$ATLAS" == "DiFuMo" ]]; then
            INTRANETWORK_FLAG=""
        else
            INTRANETWORK_FLAG="--calculate-intranetwork-average-correlation"
        fi
        echo "Running ${PARTICIPANT_LABEL} with ${ATLAS} ${STRATEGY}"
        	apptainer run \
            --bind ${FMRIPREP_DIR}:/data/input \
            --bind ${SLURM_TMPDIR}:/data/output \
            --bind ${WORKINGDIR}:/data/working \
            ${GIGA_CONNECTOME} \
            -w /data/working \
            --atlas ${ATLAS} \
            --denoise-strategy ${STRATEGY} \
            ${INTRANETWORK_FLAG} \
            /data/input \
            /data/output \
            participant \
            --participant_label ${PARTICIPANT_LABEL}
        exitcode=$?  # catch exit code
        if [ $exitcode -eq 0 ] ; then rsync -rltv --info=progress2 ${SLURM_TMPDIR}/*.h5 ${PARTICIPANT_OUTPUT} ; fi
    done
done
