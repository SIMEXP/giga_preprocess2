import os

# Directory containing sub-directories
main_directory = "/home/nclarke/scratch/compass-nd_connectome-0.4.1"

# List of file endings to check for
file_endings_to_check = [
    "atlas-DiFuMo_desc-acompcor50.h5",
    "atlas-MIST_desc-scrubbing.5.h5",
    "atlas-DiFuMo_desc-scrubbing.2+gsr.h5",
    "atlas-MIST_desc-simple+gsr.h5",
    "atlas-DiFuMo_desc-scrubbing.2.h5",
    "atlas-MIST_desc-simple.h5",
    "atlas-DiFuMo_desc-scrubbing.5+gsr.h5",
    "atlas-Schaefer20187Networks_desc-acompcor50.h5",
    "atlas-DiFuMo_desc-scrubbing.5.h5",
    "atlas-Schaefer20187Networks_desc-scrubbing.2+gsr.h5",
    "atlas-DiFuMo_desc-simple+gsr.h5",
    "atlas-Schaefer20187Networks_desc-scrubbing.2.h5",
    "atlas-DiFuMo_desc-simple.h5",
    "atlas-Schaefer20187Networks_desc-scrubbing.5+gsr.h5",
    "atlas-MIST_desc-acompcor50.h5",
    "atlas-Schaefer20187Networks_desc-scrubbing.5.h5",
    "atlas-MIST_desc-scrubbing.2+gsr.h5",
    "atlas-Schaefer20187Networks_desc-simple+gsr.h5",
    "atlas-MIST_desc-scrubbing.2.h5",
]


# Directories to exclude
excluded_directories = {"working_directory"}


# Create a dictionary to store missing directories for each file ending
missing_directories_dict = {}

# Loop over sub-directories and check for files
for directory in os.listdir(main_directory):
    if directory not in excluded_directories:
        sub_directory = os.path.join(main_directory, directory)
        if os.path.isdir(sub_directory):
            for ending in file_endings_to_check:
                if not any(f.endswith(ending) for f in os.listdir(sub_directory)):
                    if ending not in missing_directories_dict:
                        missing_directories_dict[ending] = []
                    missing_directories_dict[ending].append(directory)

# Create a separate file for each file ending listing the missing directories
for ending, missing_directories in missing_directories_dict.items():
    output_file = f"missing_{ending}.txt"
    with open(output_file, "w") as f:
        for directory in missing_directories:
            f.write(directory + "\n")
    print(f"Missing file: {ending}")
    print(f"Number of directories missing it: {len(missing_directories)}")
