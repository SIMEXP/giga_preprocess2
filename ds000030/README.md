# ds000030-fmriprep-slurm
Scripts for preprocessing the UCLA Consortium for Neuropsychiatric Phenomics LA5c Study (ds000030) with fMRIPrep2.2.7lts.
## Dependency
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)
- Python
## Retrieving data
Data is openly available on Open Neuro. See `download_dataset.sh` script.
## Note on connectome generation
- Run `generate_connnectome_slurm.sh`. Edit one script so it includes the `--reindex-bids` flag. Submit, wait until completed. Submit all other scripts.
- Was run on narval.
