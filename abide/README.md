# abide-fmriprep-slurm

Create SLURM scripts for preprocessing ABIDE 1 and 2 wih fMRIPrep.
The process was done on Compute Canada Beluga.

## Dependency

- datalad
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)

## Retrieving data

A BIDS competable version of the ABIDE dataset are avalible through [datalad repository](http://datasets.datalad.org/)

## Generating slurm jobs with fMRIPrep slurm

1. Set up your environment following [this tutorial](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)

2. Run `./generate_slurm_script.sh`. It will call `fmriprep_slurm_singularity_run.sh`; which is a modified version of `singularity_run.bash` from `fmriprep-slurm`.

    You need: root of output directory, path to bids dataset, output derivative directory name.

    A minimal use case of this version:

    ```bash
    bash ./fmriprep_slurm_singularity_run.bash \
            ${OUTPUT_ROOT_PATH} \
            ${BIDS_DATASET_PATH} \
            derivatives
    ```

3. To submit jobs for each dataset, the command to use will be similar to this.

    ```bash
    find "$OUTPUT_DIR"/.slurm/smriprep_sub-*.sh -type f | while read file; do sbatch "$file"; done
    ```

4. Archive the dataset. [See this page to learn the basics.](https://simexp-documentation.readthedocs.io/en/latest/alliance_canada/tape.html)

    The fMRIPrep data will be archived by site.
    See `archive_fmriprep_[abide|abide2].sh`.

### Use the archives

See `unarchive_data.sh` for fMRIPrep data and only extract data needed for the subsequent processes.

## Timeseries extraction and QC

The two steps can be run in parallel, but for the sake of computing time efficiency, I recommand the following procedure:

### Running the QC and then the connectomes

1. Run the QC first with the container with the `--reindex-bids` flag. The QC tool with create a `layout_index.sqlite` at the fMRIPrep derivative directory.
    You use the same path binding as the input (fMRIPrep derivative directory) for the connectome tool, so the `layout_index.sqlite` created will be used correctly.

2. Run the connectome tool with the container, submit one denoising strategy for each atlas first, so the group level atlas and grey matter mask will be created first.

3. After the first set of timeseries extraction, submit the rest of the jobs in parallel.

### Running connectome only

If you are rerunning the connectome (QC not performed)

1. Run one denoising strategy on one atlas, and use the `--reindex-bids` flag.
2. Run one denoising strategy on the remaining atlas. Use the same path binding as the input (fMRIPrep derivative directory).
3. Submit the rest of the jobs in parallel.

The base script is `connectome_slurm_abide.bash`
Submit the jobs through `submit_connectomes_abide.sh`.
In ABIDE 2, KKI and IP need a separate set of script.

## Archive other things

```
cd ~/scratch/abide1_connectomes-0.2.0
tar -vczf ~/nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_connectomes-0.2.0.tar .
cd ~/scratch/abide1_giga-auto-qc-0.3.1
tar -vczf ~/nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_giga-auto-qc-0.3.1.tar .
```

## Use the archives

fMRIPrep:

```bash
# extract file to the scratch

ARCHIVE="/nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_fmriprep-20.2.7lts"
SCRATCH_TARGET="~/scratch/abide1_fmriprep-20.2.7lts"

cd $ARCHIVE
SITES=`ls`
mkdir $SCRATCH_TARGET
cd $SCRATCH_TARGET

for site in ${SITES}; do
    site_name="${site%.*.*}"  # double extension
    mkdir -p $SCRATCH_TARGET/$site_name
    tar -xvf $ARCHIVE/$site_name.tar.gz -C $SCRATCH_TARGET/$site_name
done
=======
```bash
cd ~/scratch/abide1_connectomes-0.4.1
tar -vczf ~/nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_connectomes-0.4.1.tar.gz .
cd ~/scratch/abide1_giga-auto-qc-0.3.3
tar -vczf ~/nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_giga-auto-qc-0.3.3.tar.gz .
```
