import json
import shutil
from pathlib import Path

root_p = Path("/home/neuromod/prisme/BA")
json_file_p = "brainnetome.json"
nifti_file_p = "BN_Atlas_246_2mm.nii.gz"
output_dir = root_p
output_dir.mkdir(parents=True, exist_ok=True)

with open(json_file_p, "r") as f:
    config = json.load(f)

# Extract parameters
template = config["parameters"]["template"]
resolution = config["parameters"]["resolution"]
atlas = config["parameters"]["atlas"]
suffix = config["parameters"]["suffix"]
desc = config["desc"]

# Construct new filename
new_filename = (
    f"tpl-{template}_res-{resolution}_atlas-{atlas}_desc-{desc}_{suffix}.nii.gz"
)

# Copy and rename the atlas
output_file_path = output_dir / new_filename
shutil.copy(nifti_file_p, output_file_path)
print(f"Copied and renamed file to: {output_file_path}")
