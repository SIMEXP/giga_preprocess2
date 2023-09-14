from pathlib import Path

# Define the path to the directory containing subject directories
root_p = Path("/home/nclarke/scratch/srpbs_qc")

# Create a new TSV file for appending the data
out_p = Path(root_p / "new_file.tsv")

# Initialize a flag to identify the first TSV file
first_tsv = True

# Loop through each subject directory
for subject_dir in root_p.glob("*"):
    if subject_dir.is_dir():
        tsv_file = subject_dir / "task-rest_report.tsv"

        if tsv_file.exists():
            with tsv_file.open("r") as tsv_in:
                lines = tsv_in.readlines()
                if first_tsv:
                    # Append both lines from the first TSV file
                    with out_p.open("a") as output_tsv:
                        output_tsv.writelines(lines)
                    first_tsv = False
                else:
                    # Append only the second line from subsequent TSV files
                    if len(lines) >= 2:
                        with out_p.open("a") as output_tsv:
                            output_tsv.write(lines[1])
