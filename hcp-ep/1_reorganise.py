from pathlib import Path
import shutil

root_p = Path("/lustre04/scratch/nclarke/imagingcollection01")

# Iterate through each subject directory
for sub_directory in root_p.iterdir():
    if sub_directory.is_dir() and sub_directory.name != "manifests":
        # Check if the directory already starts with "sub-"
        if sub_directory.name.startswith("sub-"):
            continue

        sub_id = sub_directory.name.split("_")[0]

        # Create session directories
        for ses in ["ses-1", "ses-2", "ses-3"]:
            ses_dir = sub_directory / ses
            ses_dir.mkdir(parents=True, exist_ok=True)

            # Move T1 and T2 to ses-1
            if ses == "ses-1":
                # Create anat folder
                anat_dir = ses_dir / "anat"
                anat_dir.mkdir(parents=True, exist_ok=True)

                t1_dir = sub_directory / "unprocessed" / "T1w_MPR"
                t2_dir = sub_directory / "unprocessed" / "T2w_SPC"

                try:
                    for file in t1_dir.iterdir():
                        if file.name.endswith((".json", ".nii.gz")):
                            suffix = (
                                ".nii.gz"
                                if file.name.endswith(".nii.gz")
                                else file.suffix
                            )
                            new_name = f"sub-{sub_id}_{ses}_T1w{suffix}"
                            shutil.move(file, anat_dir / new_name)
                except FileNotFoundError:
                    print(f"Directory not found: {t1_dir}")

                try:
                    for file in t2_dir.iterdir():
                        if file.name.endswith((".json", ".nii.gz")):
                            suffix = (
                                ".nii.gz"
                                if file.name.endswith(".nii.gz")
                                else file.suffix
                            )
                            new_name = f"sub-{sub_id}_{ses}_T2w{suffix}"
                            shutil.move(file, anat_dir / new_name)
                except FileNotFoundError:
                    print(f"Directory not found: {t2_dir}")

            # Move first resting-state session data to ses-2, rename AP/PA as run 1/2
            if ses == "ses-2":
                # Create func folder
                func_dir = ses_dir / "func"
                func_dir.mkdir(parents=True, exist_ok=True)

                rest1_ap_dir = sub_directory / "unprocessed" / "rfMRI_REST1_AP"
                rest1_pa_dir = sub_directory / "unprocessed" / "rfMRI_REST1_PA"

                try:
                    for file_suffix in ["json", "nii.gz"]:
                        ap_file_path = (
                            rest1_ap_dir
                            / f"{sub_id}_01_MR_rfMRI_REST1_AP.{file_suffix}"
                        )
                        pa_file_path = (
                            rest1_pa_dir
                            / f"{sub_id}_01_MR_rfMRI_REST1_PA.{file_suffix}"
                        )

                        if ap_file_path.exists():
                            new_name = (
                                f"sub-{sub_id}_{ses}_task-rest_run-1_bold.{file_suffix}"
                            )
                            shutil.move(ap_file_path, func_dir / new_name)
                        else:
                            print(f"File not found: {ap_file_path}")

                        if pa_file_path.exists():
                            new_name = (
                                f"sub-{sub_id}_{ses}_task-rest_run-2_bold.{file_suffix}"
                            )
                            shutil.move(pa_file_path, func_dir / new_name)
                        else:
                            print(f"File not found: {pa_file_path}")
                except FileNotFoundError:
                    print(f"Directory not found: {rest1_ap_dir} or {rest1_pa_dir}")

            # Move second resting-state session data to ses-3, rename AP/PA as run 1/2
            if ses == "ses-3":
                # Create func folder
                func_dir = ses_dir / "func"
                func_dir.mkdir(parents=True, exist_ok=True)

                rest2_ap_dir = sub_directory / "unprocessed" / "rfMRI_REST2_AP"
                rest2_pa_dir = sub_directory / "unprocessed" / "rfMRI_REST2_PA"

                try:
                    for file_suffix in ["json", "nii.gz"]:
                        ap_file_path = (
                            rest2_ap_dir
                            / f"{sub_id}_01_MR_rfMRI_REST2_AP.{file_suffix}"
                        )
                        pa_file_path = (
                            rest2_pa_dir
                            / f"{sub_id}_01_MR_rfMRI_REST2_PA.{file_suffix}"
                        )

                        if ap_file_path.exists():
                            new_name = (
                                f"sub-{sub_id}_{ses}_task-rest_run-1_bold.{file_suffix}"
                            )
                            shutil.move(ap_file_path, func_dir / new_name)
                        else:
                            print(f"File not found: {ap_file_path}")

                        if pa_file_path.exists():
                            new_name = (
                                f"sub-{sub_id}_{ses}_task-rest_run-2_bold.{file_suffix}"
                            )
                            shutil.move(pa_file_path, func_dir / new_name)
                        else:
                            print(f"File not found: {pa_file_path}")
                except FileNotFoundError:
                    print(f"Directory not found: {rest2_ap_dir} or {rest2_pa_dir}")

        # Rename the subject directory
        new_sub_directory_name = f"sub-{sub_id}"
        new_sub_directory_path = sub_directory.parent / new_sub_directory_name
        sub_directory.rename(new_sub_directory_path)

        # Delete the unprocessed directory (remaining files no longer needed)
        unprocessed_dir = new_sub_directory_path / "unprocessed"
        if unprocessed_dir.exists() and unprocessed_dir.is_dir():
            shutil.rmtree(unprocessed_dir)

print("Reorganised subjects according to BIDS.")
