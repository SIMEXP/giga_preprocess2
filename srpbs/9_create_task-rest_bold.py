import json

# Path to directory where json will be created
path = '/lustre04/scratch/nclarke/SRPBS_OPEN_bids'

# JSON file content
json_content = {
"TaskName": "rest"
}

# Serialize JSON
json_object = json.dumps(json_content, indent=4)

with open(path+"task-rest_bold.json", "w") as file:
    file.write(json_object)

print(f"task-rest_bold.json created at'{path}'")
