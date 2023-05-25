import json

# Path to directory where task-rest_bold.json will be created
path = '/lustre04/scratch/nclarke/adni_bids_output_func/'
 
# JSON file content
json_content = { 
"TaskName": "rest"
}
 
# Serialize JSON
json_object = json.dumps(json_content, indent=4)
 
# Write to dataset_description.json
with open(path+"task-rest_bold.json", "w") as file:
    file.write(json_object)

print(f"task-rest_bold.json created at'{path}'")
