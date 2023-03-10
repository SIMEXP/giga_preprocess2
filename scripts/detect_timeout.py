import argparse
import re
from nltk import word_tokenize
from pathlib import Path

#path to directory containing error logs as .txt files
error_p = Path("__file__").resolve().parents[0] / 'adni_error_logs'

log_list = []
out_memory_list = []
time_limit_list = []
trait_list = []

for file in error_p.iterdir(): #for every file in the path
    log_list.append(file) #save the file's name in the list_files list
    with open(file) as f:
        f_lines = f.readlines() #reads over each line of the file

    for line in f_lines: #for each line of the file
        split_line = line.split() #splits the contents of each line according to white space.

        #loop through tokens and see if they correspond to common error terms. If so, add file name to list
        for token in split_line:
            if token == 'out-of-memory':
                out_memory_list.append(file.stem)

            if token == 'LIMIT': 
                time_limit_list.append(file.stem)

            if token == 'FunctionalSummaryInputSpec':
                trait_list.append(file.stem)

print ('{} error logs'.format(len(log_list)))
print ('{} may have been killed by the out-of-memory handler'.format(len(out_memory_list)))
print ('{} were cancelled due to time limit'.format(len(time_limit_list)))
print ('{} have a FunctionalSummaryInputSpec error'.format(len(trait_list)))

# find those who need to be re-run
to_rerun = out_memory_list+time_limit_list
to_rerun = set(to_rerun)
len(to_rerun)


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