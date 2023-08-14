#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-pbellec
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

module load StdEnv/2020
module load gcc/9.3.0
module load fsl/6.0.4
module load scipy-stack/2020a
module load python/3.7.9

# Set the path to the data directory
data_dir='/home/nclarke/scratch/SRPBS_OPEN_bids/data2'

# Loop through each subject directory
for subj_dir in ${data_dir}/sub-*; do
    # Check that the func directory exists for this subject
    func_dir="${subj_dir}/rsfmri"
    if [ -d "${func_dir}" ]; then
        # Change to the rsfmri directory
        cd "${func_dir}"
        # Rename all files in the rsfmri directory
        #for f in vol_*; do mv -- "$f" "${f}.nii"; done
        # Merge the .nii files using fslmerge
        subj_name=$(basename "${subj_dir}")
        output_file="${subj_name}_ses-mri_task-rest_bold.nii"
        fslmerge -t "${output_file}" *.nii
	echo "${output_file}"
    fi
done
