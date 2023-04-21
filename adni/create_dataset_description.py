import json

# Path to directory where dataset_description.json will be created
path = '/lustre04/scratch/nclarke/adni_bids_output_func/'
 
# JSON file content
json_content = { 
"Name": "ADNI", 
"BIDSVersion": "1.8.0" 
}
 
# Serialize JSON
json_object = json.dumps(json_content, indent=4)
 
# Write to dataset_description.json
with open(path+"dataset_description.json", "w") as file:
    file.write(json_object)

print(f"dataset_description.json created at'{path}'")
