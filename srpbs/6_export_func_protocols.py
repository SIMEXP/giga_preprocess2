import json
import csv
from pathlib import Path

# Root directory
root = Path('/lustre04/scratch/nclarke/SRPBS_OPEN_bids')

# Open TSV file
with open(root / 'MRI_protocols_rsMRI.tsv') as f:
    tsv = csv.reader(f, delimiter='\t')
    tsv_data = list(tsv)

    # Extract protocol numbers from the second row
    headers = tsv_data[1]

    # Iterate over each column (excluding the first column which contains the keys)
    for col_index, column in enumerate(headers[1:], start=1):
        data = {}

        # Iterate over each row, starting with the fourth row
        for row in tsv_data[1:]:
            key = row[0].replace(" ", "")  # The first column is the key. Remove spaces
            value = row[col_index]  # Get the value from the current column

            # Convert numeric strings to numbers, and fix incorrectly formatted TRs
            try:
                if "." in value:
                    value = float(value)
                elif value == "2,500" and key == "TR(s)":
                    value = 2.5
                elif value == "2,000" and key == "TR(s)":
                    value = 2
                else:
                    value = int(value)
            except ValueError:
                # If the value cannot be converted to a number, keep it as a string
                pass

            # Add the key-value pair to the dictionary
            data[key] = value

        # Rename "TR(s)" to "RepetitionTime"
        if "TR(s)" in data:
            data["RepetitionTime"] = data.pop("TR(s)")

        # Create a JSON file and save
        json_file_name = f'func_protocol_{column}_.json'
        json_file_path = root / json_file_name
        with open(json_file_path, 'w') as json_file:
            json.dump(data, json_file, indent=2, separators=(',', ': '))

    print ('Done!')
