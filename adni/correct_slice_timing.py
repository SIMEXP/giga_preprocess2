import json

# Path to directory with incorrect JSON
path = '/lustre04/scratch/nclarke/adni_bids_output_func/sub-109S4594/ses-20160502/func/'

# Open the JSON file
with open(path+'sub-109S4594_ses-20160502_task-rest_bold.json') as f:
    data = json.load(f)

# Half all the values in the SliceTiming field
data['SliceTiming'] = [x/2 for x in data['SliceTiming']]

# Save the file
with open(path+'sub-109S4594_ses-20160502_task-rest_bold.json', 'w') as f:
    json.dump(data, f, indent=4)