import csv

from pathlib import Path

root = Path('/lustre04/scratch/nclarke/SRPBS_OPEN_bids')

with open(root / 'participants.tsv') as f:
    tsv = csv.reader(f, delimiter='\t')
    tsv_data = list(tsv)

    # Get the index of the "participant_id" and "protocol" columns
    participant_id_index = tsv_data[0].index('participant_id')
    protocol_index = tsv_data[0].index('protocol')

# Loop through subject directories
subject_dir_p = root / 'data'
for subject_dir in subject_dir_p.iterdir():
    if subject_dir.is_dir():
        subject = subject_dir.name

        # Find the corresponding row in the TSV file based on the subject directory name
        row = next((row for row in tsv_data[1:] if row[participant_id_index] == subject), None)

        if row:
            # Retrieve the value from the "protocol" column
            protocol_value = row[protocol_index]
            protocol_p = root / f'func_protocol_{protocol_value}_.json'

            # If the JSON file exists, copy to func directory
            if protocol_p.exists():
                destination_p = subject_dir / 'ses-mri' / 'func' / f'{subject}_ses-mri_task-rest_bold.json'
                destination_p.parent.mkdir(parents=True, exist_ok=True)
                destination_p.write_bytes(protocol_p.read_bytes())
            else:
                print(f"No JSON file found for protocol: {protocol_value}")

        else:
            print(f"No matching row found for subject: {subject} in participants.tsv")


