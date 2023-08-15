import shutil
from pathlib import Path

root = Path('/lustre04/scratch/nclarke/SRPBS_OPEN_bids/data')

# Loop through all subject directories
for subject_dir in root.iterdir():
    if subject_dir.is_dir():
        # Create a new directory within the subject directory to represent session
        ses_dir = subject_dir / 'ses-mri'
        ses_dir.mkdir(exist_ok=True)

        # Move all scan directories into the session directory
        for sub_dir in subject_dir.iterdir():
            if sub_dir.is_dir():
                shutil.move(str(sub_dir), str(ses_dir))

        # Rename scan directories
        for scan_dir in ses_dir.iterdir():
            if scan_dir.name == 't1':
                new_scan_dir = 'anat'
            elif scan_dir.name == 'rsfmri':
                new_scan_dir = 'func'
            else:
                continue # To ignore the fmap directory
            scan_dir.rename(scan_dir.parent / new_scan_dir)

        # Rename "deface_mprage.nii"
        anat_dir = ses_dir / 'anat'
        t1_file = anat_dir / 'defaced_mprage.nii'
        if t1_file.exists():
            subject_name = subject_dir.name
            new_t1_file = anat_dir / (subject_name + '_ses-mri_T1w.nii')
            shutil.copy(str(t1_file), str(new_t1_file))  # Copy the file with new name
