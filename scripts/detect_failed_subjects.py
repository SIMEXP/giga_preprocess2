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

    error_subjects = {
        "timeout": set(),
        "out_of_memory": set(),
        "tmp_space": set(),
        "workflow": set()
    }

    for s in failed_subjects:
        try:
            with open(fmriprep_slurm_output / f"smriprep_{s}.err") as f:
                txt = f.read()
                if re.search(r'\bDUE TO TIME LIMIT\b', txt):
                    error_subjects["timeout"].add(s)
                if re.search(r'\bout-of-memory\b', txt):
                    error_subjects["out_of_memory"].add(s)
                if re.search(r'\bNo space left on device\b', txt):
                    error_subjects["tmp_space"].add(s)
        except FileNotFoundError:
            warnings.warn(f"smriprep_{s}.err not found.")

        try:
            with open(fmriprep_slurm_output / f"smriprep_{s}.out") as f:
                txt = f.read()
                if re.search(r'\bnipype.workflow ERROR\b', txt):
                    error_subjects["workflow"].add(s)
        except FileNotFoundError:
            warnings.warn(f"smriprep_{s}.out not found.")

    error_subjects["out_of_memory"] -= error_subjects["workflow"]
    error_subjects["timeout"] -= error_subjects["workflow"]
    error_subjects["timeout"] -= error_subjects["out_of_memory"]
    failed_subjects -= error_subjects["timeout"]
    failed_subjects -= error_subjects["workflow"]

    if failed_subjects:
        print(f"{len(failed_subjects)} subjects faced some error during preprocessing: {failed_subjects}")
    if error_subjects["workflow"]:
        print(f"{len(error_subjects['workflow'])} subjects were timed out and error did not get propagated: {error_subjects['workflow']}")

    if error_subjects:
        modified_slurm_dir = fmriprep_slurm_output / ".slurm_modified"
        modified_slurm_dir.mkdir(exist_ok=True)

        for error_type, subjects in error_subjects.items():
            if subjects:
                if error_type == "timeout":
                    print(f"{len(subjects)} subjects were timed out: {subjects}\nIncreased wall time and try to resubmit again.")
                    replacements = [("--time=36:00:00", "--time=48:00:00")]
                elif error_type == "out_of_memory":
                    print(f"{len(subjects)} subjects were killed by the out-of-memory handler: {subjects}\nIncreased memory and wall time and try to resubmit again.")
                    replacements = [("--time=36:00:00", "--time=48:00:00"), ("--random-seed 0", "--random-seed 0 --mem-mb 11000")]
                elif error_type == "tmp_space":
                    print(f"{len(subjects)} subjects ran out of space in local scratch: {subjects}\nAdded request for space and try to resubmit again.")
                    replacements = [("#SBATCH --mem-per-cpu=12288M", "#SBATCH --mem-per-cpu=12288M\n#SBATCH --tmp=10GB")]

                for s in subjects:
                    filename = (fmriprep_slurm_output / ".slurm" / f"smriprep_{s}.sh").resolve()
                    modified_filename = modified_slurm_dir.with_name(f"modified_smriprep_{s}.sh")
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
            "Check if the job failed. Create modified fMRIPrep SLRUM script "
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


