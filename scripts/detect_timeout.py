import warnings
import argparse
import re
from pathlib import Path

def check_timeout(args):
    fmriprep_slurm_output = args.fmriprep_slurm_output

    completed_subjects = set(
        p.name
        for p in fmriprep_slurm_output.glob("fmriprep*/sub-*")
        if p.is_dir()
    )
    submitted_subjects = set(
        p.name.split('_')[-1].split('.')[0]
        for p in fmriprep_slurm_output.glob(".slurm/smriprep_sub-*")
    )
    failed_subjects = submitted_subjects - completed_subjects

    if not failed_subjects:
        print("Data set preprocessed with no errors.")
        return

    timeout_subjects = set()
    workflow_error_subjects = set()
    out_of_memory_subjects = set()
    tmp_space_subjects = set()
    for s in failed_subjects:
        try:
            with open(fmriprep_slurm_output / f"smriprep_{s}.err") as f:
                txt=f.read()
                if re.search(r'\bDUE TO TIME LIMIT\b', txt):
                    timeout_subjects.add(s)
                if re.search(r'\bout-of-memory\b', txt):
                    out_of_memory_subjects.add(s)
                if re.search(r'\bNo space left on device\b', txt):
                    tmp_space_subjects.add(s)
        except FileNotFoundError:
            warnings.warn(f"smriprep_{s}.err not found.")

        try:
            with open(fmriprep_slurm_output / f"smriprep_{s}.out") as f:
                txt=f.read()
                if re.search(r'\bnipype.workflow ERROR\b', txt):
                    workflow_error_subjects.add(s)
        except FileNotFoundError:
            warnings.warn(f"smriprep_{s}.out not found.")

    out_of_memory_subjects -= workflow_error_subjects
    timeout_subjects -= workflow_error_subjects
    # tmp_space_subjects -= workflow_error_subjects
    timeout_subjects -= out_of_memory_subjects
    failed_subjects -= timeout_subjects
    failed_subjects -= workflow_error_subjects

    if failed_subjects:
        print(f"{len(failed_subjects)} subjects faced some error during preprocessing: {failed_subjects}")
    if workflow_error_subjects:
        print(f"{len(workflow_error_subjects)} subjects were timed out and error did not get propagated: {workflow_error_subjects}")

    if timeout_subjects or out_of_memory_subjects or tmp_space_subjects:
        # Make a new directory for modified slurm scripts
        modified_slurm_dir = fmriprep_slurm_output / ".slurm_modified"
        modified_slurm_dir.mkdir(exist_ok=True)

        if timeout_subjects:
            print(f"{len(timeout_subjects)} subjects were timed out: {timeout_subjects}"
                  "Increased wall time and try to resubmit again.")

            # Update the wall time for subjects that timed out, creating a new .slurm script
            for s in timeout_subjects:
                filename = fmriprep_slurm_output / f".slurm/smriprep_{s}.sh"
                modified_filename = modified_slurm_dir / f"modified_smriprep_{s}.sh"
                replacements = [("--time=36:00:00", "--time=48:00:00")]
                create_modified_slurm(filename, modified_filename, replacements)

        if out_of_memory_subjects:
            print(f"{len(out_of_memory_subjects)} subjects were killed by the out-of-memory handler: {out_of_memory_subjects}"
                "Increased memory and wall time and try to resubmit again.")

            # Update the wall time and add a memory upper limit for subjects that had an out-of-memory error, creating a new .slurm script
            for s in out_of_memory_subjects:
                filename = fmriprep_slurm_output / f".slurm/smriprep_{s}.sh"
                modified_filename = modified_slurm_dir / f"modified_smriprep_{s}.sh"
                replacements = [("--time=36:00:00", "--time=48:00:00"), ("--random-seed 0", "--random-seed 0 --mem-mb 11000")]
                create_modified_slurm(filename, modified_filename, replacements)

        if tmp_space_subjects:
            print(f"{len(tmp_space_subjects)} subjects ran out out of space in local scratch: {tmp_space_subjects}"
                "Added request for space and try to resubmit again.")

            # Add request for local scratch space to slurm script for these subjects, creating a new .slurm script
            for s in tmp_space_subjects:
                filename = fmriprep_slurm_output / f".slurm/smriprep_{s}.sh"
                modified_filename = modified_slurm_dir / f"modified_smriprep_{s}.sh"
                replacements = [("#SBATCH --mem-per-cpu=12288M", "#SBATCH --mem-per-cpu=12288M\n#SBATCH --tmp=10GB")]
                create_modified_slurm(filename, modified_filename, replacements)

        print(f'''Check the modified .slurm scripts in {modified_slurm_dir} and submit them with the following command:
          find "{modified_slurm_dir}" -name "modified_smriprep_sub-*.sh" -type f | while read file; do sbatch "$file"; done''')

def create_modified_slurm(filename, modified_filename, replacements):
    # read the input filename using 'with'
    with open(filename) as f:
        s = f.read()
    for old_string, new_string in replacements:
        if old_string not in s:
            print(f'"{old_string}" not found in {filename}.')
        else:
            s = s.replace(old_string, new_string)
    with open(modified_filename, "w") as f:
        f.write(s)
    return

def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
        description=(
            "Check if the job failed on timeout. Modify fMRIPrep SLRUM script "
            "accordingly."
        ),
    )
    parser.add_argument(
        "fmriprep_slurm_output",
        action="store",
        type=Path,
        help="The directory with the fMRIPrep derivative and fMRIPrep SLURM.",
    )
    args = parser.parse_args()
    check_timeout(args)


if __name__ == "__main__":
    main()







