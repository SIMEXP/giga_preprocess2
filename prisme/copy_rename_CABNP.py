import json
import shutil
from pathlib import Path

root_p = Path("/home/neuromod/prisme/CAB-NP")
json_file_p = "ColeAnticevic12.json"
nifti_file_p = "CAB-NP_volumetric_liberal_reordered.nii.gz"
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
output_file_p = output_dir / new_filename

# Copy (no need to compress)
shutil.copy(nifti_file_p, output_file_p)

print(f"Renamed file to: {output_file_p}")
