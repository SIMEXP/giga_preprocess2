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

    timeout_subjects = set()
    for s in failed_subjects:
        with open(fmriprep_slurm_output / f"smriprep_{s}.err") as f:
            txt=f.read()
            if re.search(r'\bDUE TO TIME LIMIT\b', txt):
                timeout_subjects.add(s)
                slurm_filename = fmriprep_slurm_output / f".slurm/smriprep_{s}.sh"
                inplace_change(slurm_filename, "--time=36:00:00", "--time=48:00:00")
                print(f"Resubmit this file: sbatch {str(slurm_filename)}")
    failed_subjects -= timeout_subjects
    print("The following subjects faced some error during preprocessing: "
          f"{failed_subjects}")
    print(f"The following subjects were timed out: {timeout_subjects}"
          "Increased wall time and try to resubmit again.")


def inplace_change(filename, old_string, new_string):
    # Safely read the input filename using 'with'
    with open(filename) as f:
        s = f.read()
        if old_string not in s:
            print('"{old_string}" not found in {filename}.'.format(**locals()))
            return

    # Safely write the changed content, if found in the file
    with open(filename, 'w') as f:
        print('Changing "{old_string}" to "{new_string}" in {filename}'.format(**locals()))
        s = s.replace(old_string, new_string)
        f.write(s)


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