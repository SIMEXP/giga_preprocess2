import json

# Path to directory where task-rest_bold.json will be created
path = "/home/nclarke/scratch/compass_nd/bids_release_7/"

# JSON file content
json_content = {"TaskName": "rest"}

# Serialize JSON
json_object = json.dumps(json_content, indent=2)

# Write to dataset_description.json
with open(path + "task-rest_bold.json", "w") as file:
    file.write(json_object)

print(f"task-rest_bold.json created at'{path}'")
