import os
import pandas as pd

DATA_DIR = (
    "/home/nclarke/scratch/cobre_fmriprep-20.2.7lts_1683063932/COBRE/fmriprep-20.2.7lts"
)

output_file = "/home/nclarke/projects/rrg-pbellec/nclarke/giga_preprocess2/cobre/missing_cosine00.txt"

with open(output_file, "w") as f:
    for root, dirs, files in os.walk(DATA_DIR):
        for file in files:
            if file.endswith("desc-confounds_timeseries.tsv"):
                tsv_file = os.path.join(root, file)

                # Read the TSV file into a DataFrame
                df = pd.read_csv(tsv_file, sep="\t")

                # Check if "cosine00" is a column in the DataFrame
                if "cosine00" not in df.columns:
                    # Write the message to the output file
                    f.write(f"'cosine00' column MISSING in: {tsv_file}\n")
                else:
                    f.write(f"'cosine00' column found in: {tsv_file}\n")
