import json
import csv
from pathlib import Path

# Root directory
root = Path('/lustre04/scratch/nclarke/')

# Open CSV file and create a dictionary to store the data
with open(root / 'COBRE_parameters_rest.csv') as f:
    csv_reader = csv.reader(f)
    data = {}

    # Iterate over each row in the CSV file
    for row in csv_reader:
        key = row[0].replace(" ", "") # The first column is the key. Remove spaces
        value = row[1] # The second column is the value

    # Convert numeric strings to numbers
        try:
            if "." in value:
                value = float(value)
            else:
                value = int(value)
        except ValueError:
            # If the value cannot be converted to a number, keep it as a string
            pass

        # Convert RepetitionTime to seconds
        if key == "RepetitionTime":
            value = value / 1000

        # Add the key-value pair to the dictionary
        data[key] = value

# Loop through all subject directories
for subject_dir in (root / 'COBRE').iterdir():
    subject = subject_dir.name

    # Save the JSON file for each subject
    func_json = subject_dir / 'ses-mri' / 'func' / f'{subject}_ses-mri_task-rest_bold.json'
    with open(func_json, 'w') as json_file:
        json.dump(data, json_file, indent=4, separators=(',', ': '))

    print(f'Saved JSON file to: {func_json}')
