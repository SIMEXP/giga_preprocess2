import pandas as pd

from pathlib import Path

tsv_p = Path("/home/neuromod/srpbs_qc.tsv")

df = pd.read_csv(tsv_p, sep="\t")
df = df.sort_values(by="participant_id")

# Get the minimum and maximum participant IDs in the DataFrame
min_id = df["participant_id"].min()
max_id = df["participant_id"].max()

# Create a set of all expected IDs from min_id to max_id
expected_ids = set(range(min_id, max_id + 1))

# Find the missing IDs by subtracting the set of actual IDs from the set of expected IDs
missing_ids = list(expected_ids - set(df["participant_id"]))

# Print the missing IDs
if missing_ids:
    print("Missing participant IDs:", missing_ids)
else:
    print("No missing participant IDs in the sequence.")
