import json

# Path to directory where JSON will be created
path = '/lustre04/scratch/nclarke/COBRE/'
 
# JSON file content
json_content = { 
"Name": "COBRE", 
"BIDSVersion": "1.8.0" 
}
 
# Serialize JSON
json_object = json.dumps(json_content, indent=4)
 
# Write to JSON
with open(path+"dataset_description.json", "w") as file:
    file.write(json_object)

print(f"dataset_description.json created at'{path}'")
