import warnings
import argparse
import re
from pathlib import Path
from string import Template

error_keywords = {
    "timeout": r"\bDUE TO TIME LIMIT\b",
    "out_of_memory": r"\bout-of-memory\b",
    "tmp_space": r"\bNo space left on device\b",
    "workflow": r"\bnipype.workflow ERROR\b",
}


error_message = {
    "timeout": Template(
        "$n_subject subjects were timed out: $subject_list"
        "\nIncreased wall time and try to resubmit again."
    ),
    "out_of_memory": Template(
        "$n_subject subjects were killed by the out-of-memory handler: $subject_list"
        "\nIncreased memory and wall time and try to resubmit again."
    ),
    "tmp_space": Template(
        "$n_subject subjects ran out of space in `localscratch`: $subject_list"
        "\nAdded request for 10 GB of space and try to resubmit again."
    ),
    "workflow": Template(
        "$n_subject subjects were timed out and error did not get propagated: $subject_list"
    ),
}


def check_timeout(args):
    fmriprep_slurm_output = args.fmriprep_slurm_output

    completed_subjects = set(
        p.name for p in fmriprep_slurm_output.glob("fmriprep*/sub-*") if p.is_dir()
    )
    submitted_subjects = set(
        p.name.split("_")[-1].split(".")[0]
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
        "workflow": set(),
    }

    for s in failed_subjects:
        try:
            with open(fmriprep_slurm_output / f"smriprep_{s}.err") as f:
                txt = f.read()
                for error_type in ["timeout", "out_of_memory", "tmp_space"]:
                    if re.search(error_keywords[error_type], txt):
                        error_subjects[error_type].add(s)
        except FileNotFoundError:
            warnings.warn(f"smriprep_{s}.err not found.")

        # workflow error
        try:
            with open(fmriprep_slurm_output / f"smriprep_{s}.out") as f:
                txt = f.read()
                if re.search(error_keywords["workflow"], txt):
                    error_subjects["workflow"].add(s)
        except FileNotFoundError:
            warnings.warn(f"smriprep_{s}.out not found.")

    error_subjects["out_of_memory"] -= error_subjects["workflow"]
    error_subjects["timeout"] -= error_subjects["workflow"]
    error_subjects["timeout"] -= error_subjects["out_of_memory"]
    failed_subjects -= error_subjects["timeout"]
    failed_subjects -= error_subjects["workflow"]

    if failed_subjects:
        print(
            f"{len(failed_subjects)} subjects faced some error during "
            f"preprocessing: {failed_subjects}"
        )
    if error_subjects["workflow"]:
        print(
            error_message["workflow"].substitute(
                n_subject=len(error_subjects["workflow"]),
                subject_list=error_subjects["workflow"],
            )
        )

    if _check_resubmit_subject(error_subjects):
        modified_slurm_dir = fmriprep_slurm_output / ".slurm_modified"
        modified_slurm_dir.mkdir(exist_ok=True)

        for error_type, subjects in error_subjects.items():
            if not subjects:
                continue

            replacements = _slurm_text_replacer(
                args.original_time, args.original_mem, subjects, error_type
            )

            for s in subjects:
                filename = (
                    fmriprep_slurm_output / ".slurm" / f"smriprep_{s}.sh"
                ).resolve()
                modified_filename = modified_slurm_dir / f"modified_smriprep_{s}.sh"
                _create_modified_slurm(filename, modified_filename, replacements)

        print(
            f"Check the modified .slurm scripts in {modified_slurm_dir} "
            "and submit them with the following command: "
            f'"find "{modified_slurm_dir}" -name '
            '"modified_smriprep_sub-*.sh" -type f | '
            'while read file; do sbatch "$file"; done'
        )


def _slurm_text_replacer(original_time, original_mem, error_subjects, error_type):
    """Show relevant error message and return string replacements.

    Args:
        original_time (str) : in "HH:MM:SS" format.
        original_mem (str) : original memory set for the slurm script.
        error_subjects (list): A list of subjects per error type.
        error_type (str) : error type of the following: "timeout", "out_of_memory", "tmp_space"

    Returns:
        List of tuple of original text and replacement text.
    """
    original_time_add_12 = _set_new_wall_time(original_time, 12)
    print(
        error_message[error_type].substitute(
            n_subject=len(error_subjects),
            subject_list=error_subjects,
        )
    )

    replacements = []
    if error_type in ["timeout", "out_of_memory"]:
        original = f"--time={original_time}"
        new = f"--time={original_time_add_12}"
        replacements.append((original, new))

    if error_type == "out_of_memory":
        replacements.append(("--random-seed 0", "--random-seed 0 --mem-mb 11000"))
    if error_type == "tmp_space":
        replacements.append(
            (
                f"#SBATCH --mem-per-cpu={original_mem}",
                f"#SBATCH --mem-per-cpu={original_mem}\n#SBATCH --tmp=10GB",
            )
        )

    return replacements


def _set_new_wall_time(original_time, hr_increase):
    """Add wall time.

    Args:
        original_time (str) : in "HH:MM:SS" format.
        hr_increase (int) : amount of hours to add

    Returns:
        The sum of ``original_time`` and ``hr_increase`` in "HH:MM:SS" format.
    """
    hrs, mins, secs = original_time.split(":")
    hrs = str(int(hrs) + hr_increase)
    return f"{hrs}:{mins}:{secs}"


def _check_resubmit_subject(error_subjects):
    """Chekc if any subject should be resubmitted.

    Args:
        error_subjects (dict) : Dictionary where the error type is the key and
        the value is a list of string, the strings are subject id.

    Returns:
        Boolean, if there's any subject present under any error types.
    """
    for error_type in ["timeout", "out_of_memory", "tmp_space"]:
        if not error_subjects[error_type]:
            continue
        else:  # return true when catch the first case
            return True
    return False


def _create_modified_slurm(filename, modified_filename, replacements):
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
    parser.add_argument(
        "--original_mem",
        action="store",
        type=str,
        required=False,
        default="12288M",
        help="Original memory set for the script. Default to 12288M",
    )
    parser.add_argument(
        "--original_time",
        action="store",
        type=str,
        required=False,
        default="36:00:00",
        help="Original time set for the script. Default to 36:00:00",
    )
    args = parser.parse_args()
    check_timeout(args)


if __name__ == "__main__":
    main()


def test_check_resubmit_subject():
    error_subjects = {
        "timeout": set(),
        "out_of_memory": set(),
        "tmp_space": set(["sub-003"]),
        "workflow": set(),
    }
    assert _check_resubmit_subject(error_subjects) == True

    error_subjects = {
        "timeout": set(),
        "out_of_memory": set(),
        "tmp_space": set(),
        "workflow": set(),
    }
    assert _check_resubmit_subject(error_subjects) == False


def test_set_new_wall_time():
    assert _set_new_wall_time("12:00:00", 3) == "15:00:00"
    assert _set_new_wall_time("12:44:00", 3) == "15:44:00"


def test_slurm_text_replacer():
    replacer = _slurm_text_replacer(
        original_time="12:00:00",
        original_mem="12G",
        error_subjects=set(["sub-003", "sub-010"]),
        error_type="out_of_memory",
    )
    assert len(replacer) == 2
    assert replacer[1] == ("--random-seed 0", "--random-seed 0 --mem-mb 11000")
