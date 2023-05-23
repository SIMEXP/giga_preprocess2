# giga_preprocess2

Preprocess datasets using fMRIPrep.

To clone this repository:

```
git clone  git@github.com:SIMEXP/giga_preprocess2.git
```

## Project structure

- One dataset, one directory
- Shared command line tool in `scripts/`
  - `fmriprep_slurm_singularity_run.bash`: modified version of `fmriprep-slurm` accompanied script. Allow specifying output directory.
- Documentation in `docs`