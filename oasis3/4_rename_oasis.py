from pathlib import Path

root_p = Path('/home/nclarke/scratch/oasis3_bids')

# Iterate through subject directories
for subject_dir in root_p.iterdir():
    if not subject_dir.is_dir():
        continue

    # Iterate through session directories
    for session_dir in subject_dir.iterdir():
        if not session_dir.is_dir():
            continue

        # Iterate through anat and func directories
        for subdir in session_dir.iterdir():
            if subdir.is_dir() and subdir.name in ['anat', 'func']:
                # Iterate through files in the subdirectory
                for file_p in subdir.iterdir():
                    file_name = file_p.name
                    replacements = [('sess', 'ses'),('restingstate', 'rest')]
                    new_file_name = file_name
                    for old, new in replacements:
                        new_file_name = new_file_name.replace(old, new)
                    if new_file_name != file_name:
                        #print(f"Testing rename: {file_name} -> {new_file_name}")
                        #new_file_p = file_p.with_name(new_file_name)
                        # Rename the file
                        file_p.rename(new_file_p)
                        print(f"Renamed file: {file_name} -> {new_file_name}")
                        
