# giga_preprocess2

Preprocess datasets using fMRIPrep.

To clone this repository, including the submodules:

```
git clone --recurse-submodules git@github.com:SIMEXP/giga_preprocess2.git
```

The steps used to preprocess each dataset with fMRIPrep can vary. 
Here we describe the common shared steps for datasets in BIDS format.

## Common dependency

- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
  This has been set up in the lab on Beluga.

## Procedures

### Generating slurm jobs with fMRIPrep slurm

1. Set up your environment following [this tutorial](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)

2. Use `fmriprep_slurm_singularity_run.sh` to generate slurm scripts; which is a modified version of `singularity_run.bash` from `fmriprep-slurm`.

    You need: root of output directory, path to bids dataset, output derivative directory name.

    For the preprocessing we are using fMRIPrep20.2.1lts and the `aroma` option.

    Here's an example of how to generate slurm scripts with the above parameters:

    ``` 
    bash ./fmriprep_slurm_singularity_run.bash \
        ${OUTPUT_ROOTDIR_PATH} \
        ${BIDS_DATASET_PATH} \
        fmriprep-20.2.1lts \
        --fmriprep-args=\"--use-aroma\" \
        --email=${EMAIL} \
        --time=36:00:00 \
        --mem-per-cpu=12288 \
        --cpus=1 \
        --container fmriprep-20.2.1lts
    ```

3. To submit jobs for each dataset, the command to use will be similar to this.

    ```
    find "$OUTPUT_DIR"/.slurm/smriprep_sub-*.sh -type f | while read file; do sbatch "$file"; done
    ```
    
4. Archive the dataset. [See this page](https://simexp-documentation.readthedocs.io/en/latest/alliance_canada/tape.html)

    Run the process on a computing node in a tmux session.
    ```
    tmux
    salloc --account=rrg-pbellec --mem-per-cpu=8G --time=8:00:0 --cpus-per-task=1
    ```
    After starting the session, archive the data:
    ```
    cd /path/to/fmriprep/derivative
    FILENAME=${PWD##*/} 
    tar -vcf /nearline/ctb-pbellec/giga_preprocessing_2/${FILENAME}.tar.gz .
    ```
    We do not apply the compression (`-z`) flag to save computing time. 
    
    Exit from the tmux session with key combo `ctrl-b-d`
    
## Timeseries extraction 

TBA

## Project structure

- One dataset, one directory
- Shared command line tool in `scripts/`
  - `fmriprep_slurm_singularity_run.bash`: modified version of `fmriprep-slurm` accompanied script. Allow specifying output directory.
