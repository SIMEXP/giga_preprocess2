from pathlib import Path

root = Path('/lustre04/scratch/nclarke/COBRE')

# Loop through all subject directories
for subject_dir in root.iterdir():
    if subject_dir.is_dir():
        # Rename subject directory to sub-<subject_number>
        new_subject_dir = 'sub-' + subject_dir.name
        subject_dir.rename(subject_dir.parent / new_subject_dir) # Rename
        subject_dir = subject_dir.parent / new_subject_dir # Update the path

        # Rename session directory
        session_dir = subject_dir / 'session_1'
        new_session_dir = 'ses-mri'
        session_dir.rename(session_dir.parent / new_session_dir) # Rename
        session_dir = session_dir.parent / new_session_dir # Update the path

        # Rename scan directories
        for scan_dir in session_dir.iterdir():
            if scan_dir.name == 'anat_1':
                new_scan_dir = 'anat'
            elif scan_dir.name == 'rest_1':
                new_scan_dir = 'func'
            scan_dir.rename(scan_dir.parent / new_scan_dir)

        # Rename anat
        anat_dir = session_dir /'anat'
        for file in anat_dir.iterdir():
            if file.name == 'mprage.nii.gz':
                new_file = f"{new_subject_dir}_{new_session_dir}_T1w.nii.gz"
                file.rename(file.parent / new_file)

        # Rename func
        func_dir = session_dir / 'func'
        for file in func_dir.iterdir():
            if file.name == 'rest.nii.gz':
                new_file = f"{new_subject_dir}_{new_session_dir}_task-rest_bold.nii.gz"
                file.rename(file.parent / new_file)
